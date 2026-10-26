# Darkos: Amazon Fire TV 75" Omni debloat

For the **Amazon Fire TV 75" Omni Series**: panel `AMZ_K24NE5_4K75M600A`, model `AFTTIFF43`, codename
`brandenburg`, Fire OS 7.7.1.x on Android 9. The lists come from
[cleanyourtv](https://github.com/Gathin23/cleanyourtv) `examples/amazon-fire-tv-afttiff43`, which was
tested on this exact panel, trimmed to your choices (see [`lists/KEPT.md`](lists/KEPT.md)).

**Debloat only, no new launcher.** Fire OS keeps Home for `com.amazon.tv.launcher`. It is a protected
package, `set-home-activity` is ignored, and third-party HOME priority is forced to 0. The Apple TV-style
launcher can't take over on this TV. The recommendation and sponsored rows go away once batch 2 runs,
but the hero banner at the top stays, because it's Amazon Home's own feed.

Nothing is uninstalled. Everything is `pm disable-user --user 0` and reversible.

## Before you start

- Use a computer (Mac, Linux, or Windows with Git Bash) on the **same Wi-Fi as the TV**, with
  `git` and `python3` installed.
- On the TV, go to Settings > My Fire TV > About and press OK on the device name 7 times. Then go back
  to Developer options and turn on **ADB debugging**.
- Find the TV's IP under Settings > My Fire TV > About > Network.
- Do it all in one sitting, and switch debugging off at the end (`scripts/finish.sh`).

## Run

```bash
scripts/setup.sh                               # clones cleanyourtv (pinned) and its ADB client
TV_HOST=192.168.1.50 scripts/backup.sh         # accept "Allow USB debugging?" on the TV
TV_HOST=192.168.1.50 scripts/debloat.sh        # 4 batches, screenshot + pause after each, reboot, check
TV_HOST=192.168.1.50 scripts/finish.sh         # after switching debugging off: confirms port 5555 refuses
```

Screenshots land in `shots/` and the backup in `backup/<timestamp>/`. Neither is committed: they
identify your TV. `SKIP_DNS=1` on `debloat.sh` leaves Private DNS alone.

What `debloat.sh` does:

| Batch | What goes |
|---|---|
| 1 telemetry | ACR (screen-content recognition, HDMI included), metrics, loggers, advertising ID, data pipelines |
| 2 ads | Sponsored and recommendation rows, ad bidding, Fire TV Channels, shopping, demo, tutorials, popups |
| 3 apps | Amazon Music, Photos, Kids, Luna, miniTV, ambient screensaver |
| 4 extras | Alexa alerts, notifications and Home Theater (Alexa voice stays), print services, Wi-Fi password sync |

It also turns off the autoplaying ad video in the Home banner and sets **AdGuard Private DNS**
(`dns.adguard-dns.com`). That blocks Amazon ad and tracking domains but **not YouTube ads**. It was
confirmed working on another 75" Omni.

Kept: Alexa voice, AirPlay/Miracast, Tubi, Silk, firmware updates, Live TV, HDMI, remote and
Bluetooth, keyboard, Appstore.

## Known behaviour on this TV

- **Alexa voice turns itself back on** within minutes on the Omni, so it's kept anyway. Use the
  physical mic switch on the TV to silence the far-field mics.
- Favourites on Home can keep tiles for apps that are now disabled (Music, Photos, Kids). Highlight
  the tile, press ☰ and remove it.
- Netflix, Live TV and HDMI give black or empty screenshots. That comes from DRM, not a broken
  debloat.
- The first reboot request sometimes times out without restarting. `debloat.sh` checks the uptime
  and tells you if that happened.

## Undo

Everything:

```bash
TV_HOST=192.168.1.50 scripts/restore.sh        # re-enables all lists, puts the DNS and ad-video settings back
```

One app back (Amazon Music, for example):

```bash
TV_HOST=192.168.1.50 cleanyourtv/tools/tv.py 'pm enable com.amazon.bueller.music'
```

Private DNS only: `cleanyourtv/tools/tv.py 'settings put global private_dns_mode opportunistic'`.

To keep a package next time, put a `#` in front of its line in `lists/batch-*.txt`.
