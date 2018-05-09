#!/bin/bash
echo "Starting server..."
NODE_PATH=api node api/index.js >> default.log 2>&1 &
PID=$!
echo $PID > "pid.txt"
echo "Server started [pid: $PID]"