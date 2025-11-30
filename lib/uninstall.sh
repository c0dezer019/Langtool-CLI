#!/usr/bin/env bash
set -euo pipefail

LT_CLI_DIR="${LT_CLI_DIR:-}"
PIDFILE="/tmp/langtool.pid"
ENV_CONF="$HOME/.local/environment.d/langtool-cli.conf"

echo "Uninstalling Langtool-CLI..."

# stop running process if any
if [ -s "$PIDFILE" ]; then
	pid=$(cat "$PIDFILE" 2>/dev/null || true)
	if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
		if command -v langtool >/dev/null 2>&1; then
			langtool stop || echo "warning: 'langtool stop' failed" >&2
		else
			kill "$pid" 2>/dev/null || echo "warning: failed to kill $pid" >&2
		fi
	fi
fi

# remove pidfile
rm -f -- "$PIDFILE" 2>/dev/null || true

# remove installation dir if set
[ -n "$LT_CLI_DIR" ] && [ -e "$LT_CLI_DIR" ] && rm -rf -- "$LT_CLI_DIR" 2>/dev/null && echo "Removed $LT_CLI_DIR"

# clean env config
rm -f -- "$ENV_CONF" 2>/dev/null || true

# unset vars
unset LT_CLI_DIR LT_INSTALL_DIR 2>/dev/null || true

echo "Done."

