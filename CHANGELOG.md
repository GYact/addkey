# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/), and this project adheres to
[Semantic Versioning](https://semver.org/).

## [0.1.0] - 2026-06-21

### Added
- `addkey` — enter a secret via a hidden-input dialog; writes to `.env` and
  syncs an encrypted `.env.enc`. The value is never echoed.
- `addkey init` — per-user age key + recipient setup.
- `addkey -k` — store a secret in the macOS keychain.
- `sopsify` — migrate a plaintext dotenv to the encrypted-in-git model.
- `senv-push` / `senv-pull` — re-encrypt / restore the plaintext dotenv.
- `senv-edit` / `senv-cat` — edit / inspect an encrypted `.enc` dotenv.
- Per-user recipient resolution (env -> config file -> derived from key);
  no hardcoded public key.
- `install.sh`, shellcheck + end-to-end CI.
