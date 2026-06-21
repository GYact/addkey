#!/usr/bin/env bash
# render-demo.sh - produce docs/demo.gif from docs/demo.tape.
#   Prepares an isolated sandbox (real keys untouched), then runs vhs so the
#   recording shows only the clean demo. Requires `vhs` (brew install vhs).
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SANDBOX="/tmp/addkey-demo"

command -v vhs >/dev/null 2>&1 || { echo "vhs not found (brew install vhs)"; exit 1; }

rm -rf "$SANDBOX"
mkdir -p "$SANDBOX/work"
export XDG_CONFIG_HOME="$SANDBOX/cfg"
export SOPS_AGE_KEY_FILE="$SANDBOX/keys.txt"
export PATH="$REPO_DIR/bin:$PATH"
unset SOPS_AGE_RECIPIENT 2>/dev/null || true
# Non-interactive value so the recording never triggers the GUI dialog and the
# secret value never appears on screen. (Real usage prompts you instead.)
export ADDKEY_VALUE="sk-demo-not-a-real-key"

( cd "$SANDBOX/work" && addkey init >/dev/null )

cd "$REPO_DIR"
vhs docs/demo.tape
echo "wrote: $REPO_DIR/docs/demo.gif"
