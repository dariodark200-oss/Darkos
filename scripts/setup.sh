#!/usr/bin/env bash
# Fetch cleanyourtv at the commit these lists were checked against and set up its Python ADB client.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REV=f592b6d2db0cfa0e28779660f25ff65386a5ff9b
cd "$ROOT"
if [ ! -d cleanyourtv/.git ]; then
  git clone https://github.com/Gathin23/cleanyourtv cleanyourtv
fi
git -C cleanyourtv fetch -q origin "$REV" 2>/dev/null || true
git -C cleanyourtv checkout -q "$REV"
# python3 on Mac/Linux; Git Bash on Windows often only has python (or the py launcher).
SYSPY=$(command -v python3 || command -v python || command -v py) || { echo "install Python 3 first" >&2; exit 1; }
"$SYSPY" -m venv cleanyourtv/tools/venv
VPY=cleanyourtv/tools/venv/bin/python
[ -x "$VPY" ] || VPY=cleanyourtv/tools/venv/Scripts/python.exe   # Windows layout
"$VPY" -m pip install -q -r cleanyourtv/tools/requirements.txt
echo "ready. Next: TV_HOST=<tv ip> scripts/backup.sh"
