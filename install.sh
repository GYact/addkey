#!/usr/bin/env bash
# install.sh - symlink the addkey/senv commands into a bin directory on PATH.
#   Default target: ~/.local/bin   (override with: PREFIX=/usr/local ./install.sh)
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${PREFIX:+$PREFIX/bin}"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"

mkdir -p "$BIN_DIR"
for cmd in addkey sopsify senv-push senv-pull senv-edit senv-cat; do
  ln -sf "$SRC_DIR/bin/$cmd" "$BIN_DIR/$cmd"
  printf 'linked %s -> %s\n' "$cmd" "$BIN_DIR/$cmd"
done

echo
echo "Installed to: $BIN_DIR"
case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo "NOTE: $BIN_DIR is not on your PATH. Add it, e.g.:"
     echo "  echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.zshrc" ;;
esac
echo "Next: run 'addkey init' once to set up your age key."

# Dependency hint (non-fatal).
missing=""
for dep in sops age age-keygen; do
  command -v "$dep" >/dev/null 2>&1 || missing="$missing $dep"
done
[ -z "$missing" ] || echo "Install missing deps:$missing  (macOS: brew install sops age)"
