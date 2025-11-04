#!/bin/bash

PORT=8081
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID="/tmp/langtool.pid"
LANGTOOL_JAR="$HOME/.local/share/LanguageTool-6.7-SNAPSHOT/languagetool-server.jar"
LANGTOOL_ROOT="$HOME/.local/share/LanguageTool-6.7-SNAPSHOT"

is_running() {
	[ -f "$PID" ] && ps -p "$(cat "$PID")" > /dev/null 2>&1
}

start_langtool() {
	if is_running; then
		echo "LanguageTool is already running (PID $(cat "$PID"))"
		return
	fi

	if [ $(cat "$HOME/.config/langtool/stopped.txt") = "stopped" ]; then
		sed -i '1d' $HOME/.config/langtool/stopped.txt
	fi

	echo "Starting LanguageTool"
	java -cp $LANGTOOL_JAR org.languagetool.server.HTTPServer \
 		--config $LANGTOOL_ROOT/server.properties \
  		--port $PORT \
  		--allow-origin \
	 	> $LANGTOOL_ROOT/languagetool.log 2>&1 &
	echo $! > $PID
	echo "LanguageTool server started in background (PID: $!) at port $PORT."
	echo "Log output: languagetool.log"
	echo "To stop the server, run: langtool stop"
}

stop_langtool() {
	if ! is_running; then
		echo "LanguageTool is not running."
		return
	fi
	echo "Stopping LanguageTool..."
	kill "$(cat "$PID")"
	rm -f "$PID"
	echo "Stopped."
	echo "stopped" > $HOME/.config/langtool/stopped.txt
}

case "$1" in
	start)
		start_langtool
		;;
	stop)
		stop_langtool
		;;
	restart)
		stop_langtool
		start_langtool
		;;
	status)
		if is_running; then
			echo "LanguageTool running (PID $(cat "$PID"))."
		else
			echo "LanguageTool not running."
		fi
		;;
	*)
		echo "Usage: $0 {start|stop|restart|status}"
		;;
esac
