#!/bin/bash

APP_DIR="$HOME/.local"

# Find the latest Cursor AppImage file
APPIMAGE=$(ls -t "$APP_DIR"/cursor-* 2>/dev/null | head -n 1)

if [[ -z "$APPIMAGE" ]]; then
    echo "No Cursor AppImage found in $APP_DIR."
    exit 1
fi

nohup "$APPIMAGE" "$1" > /dev/null 2>&1 & disown
