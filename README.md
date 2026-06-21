# addkey

> Hand API keys to your AI coding assistant **without ever pasting them into the chat.**

**English** | [日本語](./README.ja.md)

`addkey` pops up a hidden-input dialog, takes your secret, and writes it straight
into `.env` (plus an encrypted, commit-safe `.env.enc`). The value never touches
stdout, your shell history, or your AI assistant's conversation log.

```console
$ addkey OPENAI_API_KEY
# a GUI dialog appears -> you type the key there -> nothing is echoed
/path/to/project/.env: 'OPENAI_API_KEY' added (.enc synced) (value hidden).
```

## Why

Vibe-coding with an AI agent makes one mistake very easy: pasting a real API key
into the chat. Once it's in the conversation it may be stored, logged, or synced.
`addkey` removes the temptation — the secret is entered in a native dialog and
goes only to the file your code reads.

It pairs with [SOPS](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age)
so you get the **"encrypted in git, plaintext on disk"** model: your app and your
agent keep reading a normal `.env`, while the committed source of truth is the
encrypted `.env.enc`.

## Install

Requires `bash`, [`sops`](https://github.com/getsops/sops), and
[`age`](https://github.com/FiloSottile/age).

```bash
# macOS
brew install sops age

git clone https://github.com/GYact/addkey.git
cd addkey
./install.sh          # symlinks commands into ~/.local/bin
addkey init           # generates your age key + recipient (run once)
```

`addkey init` creates an age key at `~/.config/sops/age/keys.txt` (if missing)
and records your public recipient. **Your key, your data** — nothing is encrypted
to anyone else.

## Commands

| Command | What it does |
| --- | --- |
| `addkey NAME` | Prompt for a secret, write it to `./.env`, sync `./.env.enc`. |
| `addkey -k NAME` | Store it in the macOS keychain instead of a file. |
| `addkey -f FILE NAME` | Target a specific dotenv file (default `.env`). |
| `addkey init` | One-time setup: create/locate the age key and recipient. |
| `sopsify [FILE]` | Migrate an existing plaintext `.env` to the encrypted model. |
| `senv-push [FILE]` | Re-encrypt `.env` -> `.env.enc` after editing the plaintext. |
| `senv-pull [FILE]` | Decrypt `.env.enc` -> `.env` (new machine / recovery). |
| `senv-edit FILE.enc` | Edit the encrypted file in `$EDITOR`, re-encrypt on save. |
| `senv-cat FILE.enc` | Decrypt and print to stdout (inspection only). |

## How the recipient (public key) is resolved

No public key is hardcoded. On every encrypt, the recipient is resolved in order:

1. `$SOPS_AGE_RECIPIENT` environment variable
2. `~/.config/senv/recipient` file (written by `addkey init`)
3. Derived from your private key at `$SOPS_AGE_KEY_FILE` via `age-keygen -y`

## Security notes

- Secret **values** are never printed; only key **names** and file paths are.
- `.env` and plaintext dotenv files are git-ignored; commit the `*.enc` only.
- The age **private key** (`~/.config/sops/age/keys.txt`) must never be committed
  or shared. Back it up like a password.
- `senv-cat` *does* print decrypted values by design — don't run it where output
  is captured or logged.
- `sopsify` untracks a previously committed plaintext file, but it cannot rewrite
  git history. If a secret was already pushed, **rotate it**.

## License

[Apache-2.0](./LICENSE)
