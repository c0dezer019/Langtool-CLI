# Langtool-CLI

A lightweight Bash-based CLI tool for installing, running, and managing a local LanguageTool server. Provides simple commands to start, stop, restart, and check the status of your LanguageTool instance.

----

## Features

- **Easy Installation**: One-command bootstrap setup or manual installation
- **Automatic Configuration**: Creates `server.properties` with sensible defaults during installation
- **Smart Version Detection**: Handles LanguageTool's inconsistent version naming automatically
- **Fast Downloads**: Supports `aria2c` for parallel downloads with automatic fallback to `curl`
- **Better Error Messages**: Detailed diagnostics with automatic log display on failure
- **Background Operation**: Server runs in the background with PID tracking

----

## Quick Install

Install quickly using the bootstrap script:

```bash
curl -fsSL https://raw.githubusercontent.com/c0dezer019/langtool-cli-runner/base/setup | bash
```

This will:

1. Clone the repository to `~/.local/langtool-cli`
2. Set up environment variables in `~/.config/environment.d/langtool-cli.conf`
3. Create symlinks in `~/.local/bin` (if in your PATH)

----

## Manual Installation

Clone the repo and set both `LT_CLI_DIR` (where the CLI lives) and `LT_INSTALL_DIR` (where LanguageTool will be installed):

```bash
# Clone the repository
git clone https://github.com/c0dezer019/langtool-cli.git "$HOME/.local/langtool-cli"

# Create configuration directory and file
mkdir -p "$HOME/.config/environment.d"
cat > "$HOME/.config/environment.d/langtool-cli.conf" <<'EOF'
LT_CLI_DIR="$HOME/.local/langtool-cli"
LT_INSTALL_DIR="$HOME/.local/share/LanguageTool"
EOF

# Load the config into the current shell
export LT_CLI_DIR="$HOME/.local/langtool-cli"
export LT_INSTALL_DIR="$HOME/.local/share/LanguageTool"

# Optional: Add to PATH for easy access
mkdir -p "$HOME/.local/bin"
ln -sf "$LT_CLI_DIR/langtool" "$HOME/.local/bin/langtool"

# Make variables persistent for future shells
echo 'export LT_CLI_DIR="$HOME/.local/langtool-cli"' >> ~/.bashrc
echo 'export LT_INSTALL_DIR="$HOME/.local/share/LanguageTool"' >> ~/.bashrc
```

----

## Installing LanguageTool

After installing the CLI, you need to download and install LanguageTool itself:

```bash
# Install the latest version (default)
langtool install

# Or install a specific version by date
langtool install 20251121
```

This will:

- Download LanguageTool snapshot from `https://internal1.languagetool.org/snapshots/`
- Extract it to your `$LT_INSTALL_DIR`
- Automatically create a `server.properties` configuration file with sensible defaults
- Offer to install `aria2c` for faster downloads (optional)

----

## Usage

### Basic Commands

```bash
langtool start    # Start server in background
langtool stop     # Stop the server
langtool restart  # Restart the server
langtool status   # Show server status (running/not running)
langtool install  # Install/update LanguageTool
langtool help     # Show help information
```

### Starting with a Specific Version

```bash
langtool start -v 6.8      # Start a specific installed version
```

### Example Workflow

```bash
# First-time setup
langtool install           # Download and install LanguageTool
langtool start            # Start the server

# Later usage
langtool status           # Check if running
langtool restart          # Restart if needed
langtool stop             # Stop when done
```

----

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `LT_CLI_DIR` | Where the CLI scripts are located | _(required)_ |
| `LT_INSTALL_DIR` | Where LanguageTool is installed | _(required)_ |
| `LT_VER` | LanguageTool version to use | `latest` |

### Version Configuration

Set the `LT_VER` environment variable to control which LanguageTool version is used:

```bash
# Use latest version (default)
export LT_VER="latest"

# Use a specific date-based version
export LT_VER="20251121"

# Note: Version numbers like "6.8" may be used internally but
# the naming can vary between downloads
```

Add this to your `~/.bashrc` or `~/.zshrc` to make it persistent.

### Server Configuration

After installation, you can customize the server settings by editing:

```text
$LT_INSTALL_DIR/LanguageTool-<version>-snapshot/server.properties
```

Default configuration includes:

- Maximum text length: 50,000 characters
- Check timeout: 60 seconds
- Result caching: 10,000 entries
- Work queue size: 25 threads

See the [LanguageTool HTTP Server documentation](https://dev.languagetool.org/http-server) for all available options.

----

## Server Details

- **Port**: 8081 (hardcoded)
- **PID File**: `/tmp/langtool.pid`
- **Log File**: `$LT_INSTALL_DIR/LanguageTool-<version>-snapshot/languagetool.log`
- **CORS**: Enabled with `--allow-origin "*"` (accepts requests from any origin)

----

## Troubleshooting

### Server Won't Start

If the server fails to start, the script will automatically display the last 10 lines of the log file. Common issues:

1. **Port 8081 already in use**:

   ```bash
   # Check what's using the port
   lsof -i :8081
   # Or try a different port (requires editing the script)
   ```

2. **Java not installed**:

   ```bash
   # Install Java (Ubuntu/Debian)
   sudo apt install default-jre
   ```

3. **Missing server.properties**:

   ```bash
   # Reinstall to regenerate configuration
   langtool install
   ```

### Check Server Logs

```bash
# View the full log
cat "$LT_INSTALL_DIR"/LanguageTool-*/languagetool.log

# Watch log in real-time
tail -f "$LT_INSTALL_DIR"/LanguageTool-*/languagetool.log
```

### Version Mismatch Issues

The script handles LanguageTool's inconsistent version naming automatically. If you encounter issues:

1. Check what's actually installed:

   ```bash
   ls -la "$LT_INSTALL_DIR"
   ```

2. The script will automatically find any installed LanguageTool version if the exact version isn't found

### Manual Cleanup

```bash
# Stop the server
langtool stop

# Remove PID file if stuck
rm -f /tmp/langtool.pid

# Uninstall LanguageTool
rm -rf "$LT_INSTALL_DIR/LanguageTool-"*
rm -rf "$LT_INSTALL_DIR/src"

# Reinstall
langtool install
```

----

## Testing the API

Once the server is running, you can test it:

```bash
# Check if server is responding
curl http://localhost:8081/v2/check -d "language=en-US" -d "text=This is a test."

# Or use a more readable format
curl -X POST http://localhost:8081/v2/check \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "language=en-US" \
  -d "text=I has a mistake"
```

----

## Development

### Running Directly

```bash
# Run without installing
bash lib/langtool start
bash lib/langtool status
bash lib/langtool stop
```

### Syntax Check

```bash
# Check for syntax errors
bash -n langtool

# Or use shellcheck if installed
shellcheck langtool
```

----

## Uninstallation

```bash
# Run the uninstall script
bash lib/uninstall

# Or manually:
rm -rf "$LT_CLI_DIR"
rm -rf "$LT_INSTALL_DIR"
rm -f "$HOME/.local/bin/langtool"
# Remove the export lines from your shell RC file
```

----

## License

See the repository for license information.

## Contributing

Contributions are welcome! Please open an issue or pull request on GitHub.

## Resources

- [LanguageTool Official Site](https://languagetool.org/)
- [LanguageTool HTTP Server Documentation](https://dev.languagetool.org/http-server)
- [LanguageTool API Documentation](https://languagetool.org/http-api/)
