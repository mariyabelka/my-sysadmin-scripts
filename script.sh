#!/usr/bin/env bash

INTERVAL=10          # интервал в секундах
LOGFILE="monitor.log"

while true; do
    {
        echo "--- $(date '+%Y-%m-%d %H:%M:%S') ---"
        free -h
        df -h
        uptime
        echo
    } >> "$LOGFILE"

    sleep "$INTERVAL"
done
