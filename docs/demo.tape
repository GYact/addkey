# VHS tape for a terminal-only addkey demo.
#   Render with:  ./docs/render-demo.sh   (installs nothing; needs `vhs`)
#   Output: docs/demo.gif
#
# The render script prepares an isolated sandbox and exports the env BEFORE
# calling vhs, so this tape records only the clean demo (no setup noise).
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

# Enter the prepared sandbox without showing it (env is exported by render-demo.sh).
Hide
Type "cd /tmp/addkey-demo/work && clear" Enter
Show

Sleep 500ms
Type "# Hand an API key to your AI assistant - without pasting it in chat" Sleep 1.2s Enter
Sleep 500ms
Type "addkey OPENAI_API_KEY" Sleep 900ms Enter
Sleep 1.8s

Type "# .env holds the plaintext your app reads" Sleep 800ms Enter
Type "cat .env" Sleep 500ms Enter
Sleep 1.6s

Type "# .env.enc is encrypted & commit-safe (keys readable, values not)" Sleep 800ms Enter
Type "cat .env.enc | grep OPENAI_API_KEY" Sleep 500ms Enter
Sleep 2.6s
