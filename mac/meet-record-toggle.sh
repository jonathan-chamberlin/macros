#!/bin/bash
# Toggle screen+audio recording for a Google Meet fallback.
# - First invocation: starts ffmpeg recording (screen + Meet Input aggregate device).
# - Second invocation: SIGINTs the running ffmpeg so the file finalizes cleanly.
#
# Routing assumed (set up in Audio MIDI Setup):
#   System output = "Meet Output" (Multi-Output: Speakers + BlackHole 2ch)
#   ffmpeg input  = "Meet Input"  (Aggregate: MacBook Pro Microphone + BlackHole 2ch)

set -u

PIDFILE="/tmp/meet-record.pid"
PRIOR_OUTPUT_FILE="/tmp/meet-record.prior-output"
LOGFILE="/tmp/meet-record.log"
OUTDIR="$HOME/Desktop"
FFMPEG="/opt/homebrew/bin/ffmpeg"
SWITCH="/opt/homebrew/bin/SwitchAudioSource"
RECORDING_OUTPUT="Meet Output"
NORMAL_OUTPUT="MacBook Pro Speakers"

notify() {
  /usr/bin/osascript -e "display notification \"$1\" with title \"Meet Recorder\"" >/dev/null 2>&1 || true
}

current_output() {
  "$SWITCH" -t output -c 2>/dev/null || true
}

restore_output() {
  local prior=""
  if [ -f "$PRIOR_OUTPUT_FILE" ]; then
    prior=$(cat "$PRIOR_OUTPUT_FILE")
  fi

  if [ -z "$prior" ] || [ "$prior" = "$RECORDING_OUTPUT" ]; then
    prior="$NORMAL_OUTPUT"
  fi

  "$SWITCH" -t output -s "$prior" >/dev/null 2>&1 || true
  rm -f "$PRIOR_OUTPUT_FILE"
}

# --- STOP path ---
if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
  PID=$(cat "$PIDFILE")
  kill -INT "$PID"
  for _ in $(seq 1 80); do
    kill -0 "$PID" 2>/dev/null || break
    sleep 0.1
  done
  rm -f "$PIDFILE"
  restore_output
  notify "Stopped — file saved to Desktop"
  exit 0
fi

# If recording died or the pidfile was removed while audio stayed on the
# multi-output recording route, treat the next toggle as recovery.
if [ "$(current_output)" = "$RECORDING_OUTPUT" ]; then
  rm -f "$PIDFILE"
  restore_output
  notify "Restored audio output to $NORMAL_OUTPUT"
  exit 0
fi

# --- START path ---
# Detect screen capture video index and Meet Input audio index at runtime so we
# don't break if a webcam or external device shifts the numbering.
DEVS=$("$FFMPEG" -hide_banner -f avfoundation -list_devices true -i "" 2>&1 || true)
SCREEN_IDX=$(printf '%s\n' "$DEVS" | grep -E '\[[0-9]+\] Capture screen 0' | head -1 | sed -E 's/.*\[([0-9]+)\].*/\1/')
AUDIO_IDX=$(printf '%s\n' "$DEVS" | grep -E '\[[0-9]+\] Meet Input' | head -1 | sed -E 's/.*\[([0-9]+)\].*/\1/')

if [ -z "${SCREEN_IDX:-}" ] || [ -z "${AUDIO_IDX:-}" ]; then
  notify "ERROR — Meet Input or screen device not found. Check Audio MIDI Setup."
  echo "Failed to detect devices. Output of ffmpeg -list_devices:" >&2
  echo "$DEVS" >&2
  exit 1
fi

OUT="$OUTDIR/meet-$(date +%Y%m%d-%H%M%S).mov"

# Remember whatever output device is active right now so we can restore on stop.
"$SWITCH" -t output -c > "$PRIOR_OUTPUT_FILE" 2>/dev/null || true
"$SWITCH" -t output -s "$RECORDING_OUTPUT" >/dev/null 2>&1 || true

# Meet Input is a 3-channel aggregate: ch0 = MacBook Pro Microphone,
# ch1-2 = BlackHole 2ch (Meet's audio captured via the Multi-Output Device).
# `-ac 2` would let ffmpeg pick a default 3-to-2 matrix that treats the input as
# 2.1 (L, R, LFE) and drops/attenuates ch2, which silently strips one side of
# the remote audio AND isolates the mic to the left channel only. Confirmed by
# cross-correlation of meet-20260507-221838.mov where L-R ~= L+R, meaning the
# channels carried independent signals instead of a real stereo mix.
# Explicit pan filter: mic at 0.5 into both outputs (centered mono), BlackHole
# preserved as stereo. Both speakers carry user voice + remote audio together.
"$FFMPEG" -hide_banner -loglevel warning \
  -f avfoundation -framerate 30 -capture_cursor 1 -i "${SCREEN_IDX}:${AUDIO_IDX}" \
  -filter_complex "[0:a]pan=stereo|c0=0.5*c0+c1|c1=0.5*c0+c2[aout]" \
  -map 0:v -map "[aout]" \
  -c:v h264_videotoolbox -b:v 6M \
  -c:a aac -b:a 192k \
  -y "$OUT" \
  >"$LOGFILE" 2>&1 &

PID=$!
echo "$PID" > "$PIDFILE"

# Confirm ffmpeg actually launched (didn't immediately die from missing perms etc.)
sleep 1
if ! kill -0 "$PID" 2>/dev/null; then
  rm -f "$PIDFILE"
  restore_output
  notify "ERROR — ffmpeg failed. See /tmp/meet-record.log"
  exit 1
fi

notify "Recording → $(basename "$OUT")"
