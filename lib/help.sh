#!/bin/bash

show_help() {
	cat <<'EOF'
Langtool-CLI - LanguageTool Server Manager

USAGE:
    langtool <command> [options]

COMMANDS:
    start       Start the LanguageTool server in the background
    stop        Stop the running LanguageTool server
    restart     Restart the LanguageTool server
    status      Check if the server is running
    help        Display this help message

ENVIRONMENT VARIABLES:
    LT_INSTALL_DIR (required)
        Directory where LanguageTool is installed
        Example: $HOME/.local/share/LanguageTool

    LT_CLI_DIR (required for installation)
        Directory where this CLI is located
        Example: $HOME/.local/langtool-cli

    LT_VER (optional)
        LanguageTool version to use
        Default: 6.8

CONFIGURATION:
    The server runs on port 8081 by default.
    Process ID is stored in: /tmp/langtool.pid
    Logs are written to: $LT_INSTALL_DIR/LanguageTool-$LT_VER-SNAPSHOT/languagetool.log

EXAMPLES:
    # Start the server
    langtool start

    # Check if server is running
    langtool status

    # Stop the server
    langtool stop

    # Use a different version
    LT_VER="6.9" langtool start

SETUP:
    If you haven't set up the required environment variables, add these to
    your ~/.bashrc or ~/.zshrc:

        export LT_CLI_DIR="$HOME/.local/langtool-cli"
        export LT_INSTALL_DIR="$HOME/.local/share/LanguageTool"

    Or create a config file at ~/.config/environment.d/langtool-cli.conf

For more information, visit: https://github.com/c0dezer019/langtool-cli
EOF
}

show_help
