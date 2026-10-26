# Shared by the scripts in this folder. Source it, don't run it.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CYT="$ROOT/cleanyourtv"                       # upstream checkout made by setup.sh
PY="$CYT/tools/venv/bin/python"
LISTS=("$ROOT"/lists/batch-*.txt)
STOCK_HOME=com.amazon.tv.launcher

: "${TV_HOST:?set TV_HOST to the TV IP, e.g. TV_HOST=192.168.1.50 $0}"
export TV_HOST
[ -x "$PY" ] || { echo "run scripts/setup.sh first" >&2; exit 1; }

tv() { "$PY" -I "$CYT/tools/tv.py" "$@"; }
pause() { read -r -p "$1 [Enter to continue, Ctrl-C to stop] " _; }
