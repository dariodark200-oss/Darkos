# Deliberately left enabled

Owner's choice (2026-10-26):

- **Alexa voice**: `com.amazon.vizzini`, `com.amazon.alexamediaplayer.runtime.ftv`,
  `com.amazon.alexa.externalmediaplayer.fireos`. On the Omni, vizzini re-enables itself within
  minutes anyway; the TV's physical microphone switch is the reliable way to silence the far-field mics.
- **Casting**: AirPlay (`com.apple.airplay.amazon.airplay`), Miracast (`com.amazon.cast.sink`), DIAL.
- **Tubi** (`com.tubitv.ott`), **Silk** (`com.amazon.cloud9`, `com.amazon.tv.website_launcher`).
- **Firmware updates**: the OTA packages, and also `com.amazon.tv.easyupgrade`, which the upstream
  Omni list disables as an upgrade-promo package. An Amazon Fire TV Stick session kept it to protect
  updates, so it stays on here.

Never touched (the TV needs them): Live TV and channel scan, HDMI inputs (`com.mediatek.tvinput`),
remote and Bluetooth pairing, the on-screen keyboard, the Appstore, account and sync services,
`com.amazon.tv.launcher` (Fire OS Home, protected).

Protected by Fire OS (`Cannot disable a protected package`), so not listed:
`com.fireos.usagestats.proxy`, `com.amazon.device.crashmanager`, `com.amazon.device.metrics`,
`com.amazon.ftvads.deeplinking`.
