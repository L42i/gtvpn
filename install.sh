#!/usr/bin/env bash
# Link gtvpn into ~/.local/bin and check dependencies.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$HOME/.local/bin"
ln -sf "$here/gtvpn" "$HOME/.local/bin/gtvpn"
echo "Linked ~/.local/bin/gtvpn -> $here/gtvpn"

missing=()
command -v openconnect >/dev/null || missing+=(openconnect)
python3 -c 'import pexpect' 2>/dev/null || missing+=(python3-pexpect)
python3 -c 'import keyring' 2>/dev/null || missing+=(python3-keyring)
if ((${#missing[@]})); then
    echo "Missing packages; install with:  sudo apt install ${missing[*]}"
fi
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) echo "Add ~/.local/bin to your PATH.";; esac
echo "Then run:  gtvpn setup"
