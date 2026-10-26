#!/usr/bin/env bash
# Save the TV's state before anything changes. Writes backup/<timestamp>/ and points backup/latest at it.
source "$(dirname "$0")/common.sh"
echo "Connecting to $TV_HOST. If the TV shows \"Allow USB debugging?\", tick Always allow and press OK."
tv --probe
DIR="$ROOT/backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$DIR"
tv 'pm list packages -f'          > "$DIR/packages.txt"
tv 'pm list packages -d'          > "$DIR/disabled.txt"
tv 'getprop'                      > "$DIR/getprop.txt"
for ns in global secure system; do tv "settings list $ns" > "$DIR/settings-$ns.txt"; done
tv 'cmd package resolve-activity -a android.intent.action.MAIN -c android.intent.category.HOME' > "$DIR/home.txt" || true
tv 'dumpsys connectivity' | grep -o 'Transports: [A-Z]*' | sort -u > "$DIR/transport.txt" || true
ln -sfn "$DIR" "$ROOT/backup/latest"
grep -E 'ro.product.model|ro.build.version.name|ro.build.display.id|ro.product.name' "$DIR/getprop.txt" || true
echo "already disabled before we start: $(grep -c . "$DIR/disabled.txt" || true)"
echo "network: $(tr '\n' ' ' < "$DIR/transport.txt")"
echo "backup saved in $DIR"
