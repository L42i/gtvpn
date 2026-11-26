# gtvpn

One command to connect to the Georgia Tech GlobalProtect VPN (`vpn.gatech.edu`) from Linux
using [openconnect](https://www.infradead.org/openconnect/), with no manual prompts:
username, password, Duo second factor and gateway are all answered automatically.

## Install

```bash
git clone <this repo> && cd gtvpn
./install.sh          # symlinks gtvpn into ~/.local/bin, checks dependencies
gtvpn setup           # stores your GT username and password
```

Dependencies (Debian/Ubuntu): `openconnect`, `python3-pexpect`, `python3-keyring`,
and a Secret Service keyring (KDE Wallet or GNOME Keyring).

## Usage

```bash
gtvpn            # connect; stays in the terminal, Ctrl-C disconnects
gtvpn status     # from another terminal
gtvpn off        # disconnect from another terminal
gtvpn setup      # change stored username / password
```

You'll be asked for your sudo password, then approve the Duo push on your phone
(twice: once for the portal, once for the gateway).

### Options (environment variables)

| Variable        | Default          | Meaning |
|-----------------|------------------|---------|
| `GTVPN_DUO`     | `push2`          | Answer to the Duo prompt: `push`, `push2`, `phone`, `phone2`, or a passcode |
| `GTVPN_GATEWAY` | `DC`             | Gateway to use: `DC` or `NI` |
| `GTVPN_SERVER`  | `vpn.gatech.edu` | Host to log in to; a gateway host such as `dc-ext-gw.vpn.gatech.edu` skips the portal |

Example: `GTVPN_DUO=push GTVPN_GATEWAY=NI gtvpn`

## Where credentials live

Nothing secret is stored in this repo or in plain text:

- **Username**: `~/.config/gtvpn/user`
- **Password**: your desktop keyring (Secret Service, service name `gtvpn`), via Python `keyring`.
  It is handed to the root helper over a pipe, never on a command line.

The script stops after two rejected passwords so a stale password can't lock your account;
run `gtvpn setup` to update it.
