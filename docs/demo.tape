# VHS tape for a terminal-only addkey demo.
#   Render with:  vhs docs/demo.tape   (install: brew install vhs)
#   Output: docs/demo.gif
#
# NOTE: the real GUI dialog is a native window VHS can't capture. This tape
# uses ADDKEY_VALUE to script the value so the terminal flow renders headlessly.
# For the "hero" GIF showing the actual dialog, screen-record it (see sns-posts.txt).

Output docs/demo.gif

Set Shell "bash"
Set FontSize 22
Set Width 1100
Set Height 600
Set Padding 24
Set Theme "Catppuccin Mocha"

# Isolated sandbox so a real key is never touched.
Hide
Type "export XDG_CONFIG_HOME=$(mktemp -d) SOPS_AGE_KEY_FILE=$(mktemp -u)" Enter
Type "export PATH=$PWD/bin:$PATH; cd $(mktemp -d)" Enter
Type "addkey init >/dev/null 2>&1; clear" Enter
Show

Type "# Hand an API key to your AI assistant — without pasting it in chat" Sleep 1.2s Enter
Sleep 600ms
Type "addkey OPENAI_API_KEY" Sleep 800ms Enter
Sleep 400ms
Hide
Type "ADDKEY_VALUE='sk-demo-not-a-real-key' addkey OPENAI_API_KEY" Enter
Show
Sleep 1.5s

Type "# .env holds the plaintext your app reads" Sleep 800ms Enter
Type "cat .env" Sleep 600ms Enter
Sleep 1.5s

Type "# .env.enc is encrypted & commit-safe (keys readable, values not)" Sleep 800ms Enter
Type "cat .env.enc | grep OPENAI_API_KEY" Sleep 600ms Enter
Sleep 2.5s
