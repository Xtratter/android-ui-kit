#!/data/data/com.termux/files/usr/bin/bash
# install.sh <android-project-dir> — copy the kit into <project>/app/src/main/java/io/github/xtratter/uikit/
#   CHECK=1 install.sh <dir> — only show what differs, change nothing
# Files are copied, not linked: the project builds on its own (F-Droid, plain Gradle), no network dependency.
set -euo pipefail
P=${1:?usage: [CHECK=1] install.sh <android-project-dir>}
SRC=$(cd "$(dirname "$0")" && pwd)
DST="$P/app/src/main/java/io/github/xtratter/uikit"
REV=$(git -C "$SRC" describe --tags --always --dirty 2>/dev/null || echo dev)
mkdir -p "$DST"
for f in "$SRC"/uikit/*.kt; do
    n=$(basename "$f")
    tmp=$(mktemp)
    { echo "// Copied from github.com/Xtratter/android-ui-kit ($REV) — edit there and re-run install.sh"; cat "$f"; } > "$tmp"
    if [ "${CHECK:-0}" = 1 ]; then
        diff -q <(tail -n +2 "$DST/$n" 2>/dev/null) "$f" >/dev/null && echo "  same     $n" || echo "  differs  $n"
        rm -f "$tmp"
    else
        mv "$tmp" "$DST/$n"; echo "  copied   $n"
    fi
done
