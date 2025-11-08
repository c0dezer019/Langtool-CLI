# Langtool-CLI

Small helper scripts to install, run and manage a local LanguageTool server.

----

## Quick install

Install quickly using the bootstrap script:

```bash
curl -fsSL https://raw.githubusercontent.com/c0dezer019/langtool-cli-runner/base/setup | bash
```

### Manual installation

Clone the repo and set both `LT_CLI_DIR` (where the CLI lives) and `LT_INSTALL_DIR` (where LanguageTool is installed). Persist these values in your shell rc or the installer config location.

```bash
# Minimal, copy-paste friendly manual install:
git clone https://github.com/c0dezer019/langtool-cli.git "$HOME/.local/langtool-cli"

mkdir -p "$HOME/.config/environment.d"
cat > "$HOME/.config/environment.d/langtool-cli.conf" <<'EOF'
LT_CLI_DIR="$HOME/.local/langtool-cli"
LT_INSTALL_DIR="$HOME/.local/share/LanguageTool"
EOF

# Load the config into the current shell (no rc edits performed automatically)
source "$HOME/.config/environment.d/langtool-cli.conf"

# To make variables persistent for future interactive shells, add the two export lines
# above to your ~/.bashrc or ~/.zshrc manually.
```

### Configuring the version

The `LT_VER` environment variable controls which LanguageTool release is used. Change it in your shell config, e.g.:

```bash
export LT_VER="6.8"
```

## Usage

```bash
langtool start    # start server in background
langtool stop     # stop server
langtool restart  # restart server
langtool status   # show status
```
