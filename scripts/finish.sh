#!/usr/bin/env bash
# After debugging is switched off on the TV: check that network ADB really refuses connections.
source "$(dirname "$0")/common.sh"
cat <<'MSG'
On the TV:
  1. Settings > My Fire TV > Developer options: turn ADB debugging OFF.
  2. Same menu: revoke USB debugging authorisations, if your build shows that entry.
  3. Settings > My Fire TV > Restart.
MSG
pause "Done all three, and the TV is back on?"
"$PY" -I "$CYT/tools/adb-closed.py" "$TV_HOST" && echo "Port 5555 is closed. All done."
