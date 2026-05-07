# Meet Recording — Setup

One-shortcut screen + audio recorder. Press `Cmd+Option+R` to start recording the
screen plus your mic plus the other person's voice on a Google Meet (or any app
that plays through system audio). Press `Cmd+Option+R` again to stop. The .mov
finalizes on your Desktop.

The Hammerspoon binding lives in `meet-record.lua`. The actual recording logic
lives in `meet-record-toggle.sh`. This file is the one-time install guide for
the audio plumbing the script depends on.

## What you need installed

| Tool | Purpose | Install |
|---|---|---|
| BlackHole 2ch | Virtual audio loopback driver — exposes "what's playing" as a recordable input | [Signed .pkg from existential.audio](https://existential.audio/blackhole/) (the Homebrew cask was broken at one point with an upstream API regression — use the .pkg if it fails) |
| ffmpeg | Records screen + audio | `brew install ffmpeg` |
| switchaudio-osx | CLI to flip the active output device on start/stop | `brew install switchaudio-osx` |

After installing BlackHole, run `sudo killall coreaudiod` so Core Audio re-enumerates devices without a reboot.

## Audio MIDI Setup

Open **Audio MIDI Setup** (`/System/Applications/Utilities/Audio MIDI Setup.app`).

### 1. Create the Multi-Output Device — name it `Meet Output`

`+` (bottom-left) → **Create Multi-Output Device**.

| Setting | Value |
|---|---|
| Primary Device | **MacBook Pro Speakers** ⚠ critical, see gotcha below |
| Sample Rate | 48.0 kHz |
| Use ✓ MacBook Pro Speakers | Drift Correction ☐ |
| Use ✓ BlackHole 2ch | Drift Correction ✓ |

Rename in the sidebar to `Meet Output` (double-click the device name).

> **Gotcha — the bug that took an hour to diagnose.**
> If `Primary Device` is set to **BlackHole 2ch**, the Multi-Output engine on
> Apple Silicon Macs (verified on macOS 26 Tahoe) silently fails to drive the
> BlackHole sub-device. You hear sound from the speakers but recordings come
> back as digital silence (-91 dB). Always make the **physical** device the
> Primary, with Drift Correction on the **virtual** device.

### 2. Create the Aggregate Device — name it `Meet Input`

`+` → **Create Aggregate Device**.

| Setting | Value |
|---|---|
| Clock Source | **MacBook Pro Microphone** |
| Use ✓ MacBook Pro Microphone | Drift Correction ☐ |
| Use ✓ BlackHole 2ch | Drift Correction ✓ |

Rename to `Meet Input`.

The aggregate becomes a 2.1 (3-channel) device: ch 0 = mic, ch 1+2 = BlackHole L+R.
ffmpeg's `-ac 2` downmix correctly mixes all three into the final stereo track,
so both sides of the conversation land in the .mov.

## Verify the routing

```bash
SwitchAudioSource -s "Meet Output"
( ffmpeg -hide_banner -loglevel error -f avfoundation -i ":BlackHole 2ch" \
    -t 5 -y /tmp/bh.m4a & )
sleep 0.8
say -v Samantha "routing test one two three"
sleep 5
ffmpeg -hide_banner -i /tmp/bh.m4a -af volumedetect -f null - 2>&1 | grep mean
SwitchAudioSource -s "MacBook Pro Speakers"
```

Expected: `mean_volume` around -20 dB. If you see -91 dB, the BlackHole sub-device
isn't receiving audio — re-check the Primary Device setting on Meet Output.

## Permissions

On the first `Cmd+Option+R`, macOS will prompt for **Screen Recording** permission
on whatever process invoked ffmpeg (Hammerspoon, since the binding is in
`meet-record.lua`). Approve in System Settings → Privacy & Security → Screen
Recording. Restart Hammerspoon afterward.

Microphone permission is requested separately the first time the aggregate device
is opened for capture. Approve under Privacy & Security → Microphone.

## Files

| File | Role |
|---|---|
| `mac/meet-record.lua` | Hammerspoon module — binds `Cmd+Option+R` to the toggle script |
| `mac/meet-record-toggle.sh` | The actual start/stop logic — ffmpeg, device detection, output-switch save/restore |

The toggle script writes:

- Output: `~/Desktop/meet-YYYYMMDD-HHMMSS.mov`
- PID file: `/tmp/meet-record.pid`
- Prior output device (for restore on stop): `/tmp/meet-record.prior-output`
- ffmpeg log: `/tmp/meet-record.log` (check this if the start notification says ERROR)

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| Recording is silent | `Meet Output` Primary Device is set to BlackHole | Switch it to MacBook Pro Speakers in Audio MIDI Setup |
| Notification says "ERROR — Meet Input or screen device not found" | Aggregate device renamed or deleted | Recreate `Meet Input` per section 2 |
| Notification says "ERROR — ffmpeg failed" | Screen Recording permission missing, or ffmpeg path wrong | Check `/tmp/meet-record.log`; grant Screen Recording to Hammerspoon |
| Speakers play during recording but mic isn't in the file | `Meet Input` aggregate doesn't include the mic, or mic permission missing | Re-check Audio MIDI Setup; approve mic permission |
| Output stays on Meet Output after stop | `/tmp/meet-record.prior-output` was empty when recording started (you were already on Meet Output) | Manually switch back: `SwitchAudioSource -s "MacBook Pro Speakers"` |
