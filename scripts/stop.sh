#!/bin/bash
echo "Stopping server..."
if [ -f pid.txt ]; then
	pid=$(head -n 1 "pid.txt")
	kill $pid
	rm pid.txt
	echo "Server stopped [pid: $pid]"
else
	echo "No pid.txt file found."
fi