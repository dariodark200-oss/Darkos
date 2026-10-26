#!/usr/bin/env bash
# Disable the four lists in lists/ one batch at a time, with a Home screenshot after each,
# then optional settings (ad video off, AdGuard Private DNS), a reboot and a check that it all stuck.
source "$(dirname "$0")/common.sh"
[ -d "$ROOT/backup/latest" ] || { echo "run scripts/backup.sh first" >&2; exit 1; }
SHOTS="$ROOT/shots"; mkdir -p "$SHOTS"

MODEL=$(tv 'getprop ro.product.model' | tr -d '\r')
if [ "$MODEL" != "AFTTIFF43" ]; then
  echo "This TV reports model '$MODEL', not AFTTIFF43 (the 75\" Omni these lists were tested on)."
  pause "Continue anyway?"
fi

tv --screenshot "$SHOTS/00-before.png" HOME --wait 3 || true
n=0
for list in "${LISTS[@]}"; do
  n=$((n+1))
  echo; echo "== batch $n: $(basename "$list")"
  "$CYT/tools/disable.sh" "$list"
  tv --screenshot "$SHOTS/0$n-after-$(basename "$list" .txt).png" HOME --wait 3 || true
  echo "screenshot: $SHOTS/0$n-after-$(basename "$list" .txt).png"
  pause "Check the TV: Home loads, the remote works, an HDMI input still shows a picture."
done

echo; echo "== settings"
# Autoplaying ad video in the Home hero banner. Old value is in backup/latest/settings-global.txt.
tv 'settings put global com.amazon.tv.settings.featured_item_video_enabled 0'
if [ "${SKIP_DNS:-0}" != 1 ]; then
  # AdGuard Private DNS: blocks Amazon ad/tracking domains, not YouTube ads.
  tv 'settings put global private_dns_specifier dns.adguard-dns.com'
  tv 'settings put global private_dns_mode hostname'
  echo "Private DNS set to dns.adguard-dns.com. Open an app (YouTube, Netflix) and check it still plays."
  pause "Does it play?"
fi

echo; echo "== reboot"
sleep 20   # Android writes package state to disk with a delay; rebooting at once can lose the last change
UP_BEFORE=$(tv 'cat /proc/uptime' | cut -d. -f1)
tv --reboot || true
echo "waiting for the TV to come back..."
for _ in $(seq 1 40); do
  sleep 6
  UP=$(tv 'cat /proc/uptime' 2>/dev/null | cut -d. -f1) || continue
  [ -n "$UP" ] && [ "$UP" -lt "$UP_BEFORE" ] && break
done
[ -n "${UP:-}" ] && [ "$UP" -lt "$UP_BEFORE" ] || { echo "the TV did not restart (uptime not reset): run tools/tv.py --reboot again, then re-check"; exit 1; }
sleep 30
tv --screenshot "$SHOTS/10-after-reboot.png" HOME --wait 3 || true

echo; echo "== still disabled after reboot?"
NOW=$(tv 'pm list packages -d' | sed 's/^package://' | tr -d '\r')
INSTALLED=$(tv 'pm list packages' | sed 's/^package://' | tr -d '\r')
for list in "${LISTS[@]}"; do
  grep -vE '^\s*(#|$)' "$list" | awk '{print $1}' | while read -r p; do
    if ! grep -qx "$p" <<<"$INSTALLED"; then echo "  not installed: $p"
    elif ! grep -qx "$p" <<<"$NOW"; then echo "  RE-ENABLED:    $p"; fi
  done
done
echo "Anything marked RE-ENABLED is turned back on by Fire OS at boot; note it, don't fight it."
echo "Now press Home, Input, Settings, Alexa and the app buttons on the real remote, then run scripts/finish.sh."
