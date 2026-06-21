# Contributing

Thanks for your interest! This is a small, dependency-light shell toolkit.

## Ground rules

- Keep everything POSIX-friendly `bash`; no new runtime dependencies beyond
  `sops` and `age`.
- **Never** print secret values to stdout/stderr.
- **Never** hardcode an age recipient/public key.
- Lint before opening a PR: `shellcheck -x bin/* lib/*.sh install.sh`.

## Local testing

Run the scripts against a throwaway config so your real key is untouched:

```bash
T=$(mktemp -d)
export XDG_CONFIG_HOME="$T/config" SOPS_AGE_KEY_FILE="$T/keys.txt"
export PATH="$PWD/bin:$PATH"
cd "$T"
addkey init
ADDKEY_VALUE="sk-test-123" addkey OPENAI_API_KEY   # ADDKEY_VALUE skips the GUI
senv-cat .env.enc
```

## Pull requests

- One logical change per PR, with a clear description.
- Update the README(s) if behavior changes.
- By contributing you agree your work is licensed under Apache-2.0.
