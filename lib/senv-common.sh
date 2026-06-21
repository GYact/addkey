# shellcheck shell=bash
# senv-common.sh - shared helpers for the addkey / senv toolkit.
#   Sourced by every command. Contains NO secrets and NO hardcoded recipients.
#
# Design notes:
#   - The age recipient (public key) is resolved per-user, never hardcoded.
#   - Secret VALUES are never written to stdout/stderr; only key NAMES and paths.

# --- paths -------------------------------------------------------------------
: "${SOPS_AGE_KEY_FILE:=$HOME/.config/sops/age/keys.txt}"
export SOPS_AGE_KEY_FILE
SENV_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/senv"
SENV_RECIPIENT_FILE="$SENV_CONFIG_DIR/recipient"

# --- output helpers ----------------------------------------------------------
senv_die()  { printf 'Error: %s\n' "$*" >&2; exit 1; }
senv_warn() { printf 'Warning: %s\n' "$*" >&2; }
senv_info() { printf '%s\n' "$*"; }

# --- dependency checks -------------------------------------------------------
senv_require() {
  local missing=0 c
  for c in "$@"; do
    command -v "$c" >/dev/null 2>&1 || { printf 'Error: required command not found: %s\n' "$c" >&2; missing=1; }
  done
  [ "$missing" -eq 0 ] || senv_die "install missing dependencies (macOS: brew install sops age)"
}

# --- recipient resolution ----------------------------------------------------
# Priority: $SOPS_AGE_RECIPIENT  ->  ~/.config/senv/recipient  ->  derive from key file.
# Echoes the age recipient (public key) on success; dies with a setup hint otherwise.
senv_resolve_recipient() {
  if [ -n "${SOPS_AGE_RECIPIENT:-}" ]; then
    printf '%s\n' "$SOPS_AGE_RECIPIENT"; return 0
  fi
  if [ -s "$SENV_RECIPIENT_FILE" ]; then
    sed -n '1p' "$SENV_RECIPIENT_FILE"; return 0
  fi
  if [ -s "$SOPS_AGE_KEY_FILE" ] && command -v age-keygen >/dev/null 2>&1; then
    local pub
    pub=$(age-keygen -y "$SOPS_AGE_KEY_FILE" 2>/dev/null | sed -n '1p')
    if [ -n "$pub" ]; then printf '%s\n' "$pub"; return 0; fi
  fi
  senv_die "no age recipient configured. Run 'addkey init' or set SOPS_AGE_RECIPIENT."
}

# --- git helpers -------------------------------------------------------------
# Stop a plaintext file from being tracked by git (rewriting history is the user's job).
senv_git_untrack() {
  local src="$1" dir repo rel
  dir=$(dirname "$src")
  repo=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null || true)
  [ -n "$repo" ] || return 0
  rel="$(git -C "$dir" rev-parse --show-prefix 2>/dev/null)$(basename "$src")"
  if git -C "$repo" rm --cached "$rel" >/dev/null 2>&1; then
    senv_info "  untracked from git: $rel"
  fi
}
