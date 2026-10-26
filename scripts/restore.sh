#!/usr/bin/env bash
# Undo scripts/debloat.sh: re-enable every listed package (using the state cleanyourtv recorded before
# each batch) and put back the ad-video and Private DNS settings.
source "$(dirname "$0")/common.sh"
for (( i=${#LISTS[@]}-1; i>=0; i-- )); do
  echo "== restoring $(basename "${LISTS[$i]}")"
  "$CYT/tools/restore.sh" "${LISTS[$i]}" "$STOCK_HOME"
done
B="$ROOT/backup/latest/settings-global.txt"
old() { grep -m1 "^$1=" "$B" 2>/dev/null | cut -d= -f2- | tr -d '\r'; }
v=$(old com.amazon.tv.settings.featured_item_video_enabled)
if [ -n "$v" ]; then tv "settings put global com.amazon.tv.settings.featured_item_video_enabled $v"
else tv 'settings delete global com.amazon.tv.settings.featured_item_video_enabled'; fi
mode=$(old private_dns_mode); spec=$(old private_dns_specifier)
tv "settings put global private_dns_mode ${mode:-opportunistic}"
if [ -n "$spec" ]; then tv "settings put global private_dns_specifier $spec"
else tv 'settings delete global private_dns_specifier'; fi
echo "restored. Reboot the TV once (tools/tv.py --reboot) so every service starts again."
