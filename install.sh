#! /bin/bash

CURRENT_DIR=$(pwd)

cd /tmp

CURRENT_VERSION=""
if [ -f "/usr/share/applications/cursor.desktop" ]; then
    CURRENT_VERSION=$(grep "^Version=" /usr/share/applications/cursor.desktop | cut -d'=' -f2 || echo "")
fi

API_RESPONSE=$(curl -sL "https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable")
LATEST_DOWNLOAD_URL=$(echo "$API_RESPONSE" | jq -r '.downloadUrl')
LATEST_VERSION=$(echo "$API_RESPONSE" | jq -r '.version')

if [ -z "$CURRENT_VERSION" ] || [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
    echo "Downloading latest version of Cursor (v$LATEST_VERSION)…"
    curl -sL "$LATEST_DOWNLOAD_URL" -o cursor.appimage
    sudo mv cursor.appimage /opt/cursor.appimage
    sudo chmod +x /opt/cursor.appimage
    echo "Cursor updated ($LATEST_VERSION)."
else
    echo "Cursor is already the newest version ($CURRENT_VERSION)."
fi
# Check if fuse3 is installed and up to date
if ! dpkg -l | grep -q "^ii.*fuse3"; then
    sudo apt install -y fuse3
fi
if apt-cache show libfuse2t64 > /dev/null 2>&1; then
  sudo apt install -y libfuse2t64
fi

DESKTOP_FILE="/usr/share/applications/cursor.desktop"
ICON_DIR="$HOME/.local/share/applications/icons"

sudo bash -c "cat > $DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=Cursor
Comment=AI-powered code editor
Exec=/opt/cursor.appimage --no-sandbox
Icon=$ICON_DIR/cursor.png
Type=Application
Categories=Development;IDE;
Version=$LATEST_VERSION
EOL

if [ ! -d "~/.local/bin/launch_cursor" ]; then
  curl -sL https://raw.githubusercontent.com/kuartz-org/install_cursor/refs/heads/main/launch_cursor -o ~/.local/bin/launch_cursor
  chmod +x ~/.local/bin/launch_cursor
fi

mkdir -p "$ICON_DIR"
if [ ! -f "$ICON_DIR/cursor.png" ]; then
  curl -sL https://raw.githubusercontent.com/kuartz-org/install_cursor/refs/heads/main/cursor.png -o "$ICON_DIR/cursor.png"
fi

if ! zsh -ic 'alias cursor' >/dev/null 2>&1; then
  echo "alias cursor='launch_cursor .'" >>~/.zshrc
  echo "Cursor installed successfully."
  echo "Use 'cursor' command to launch Cursor"
fi

cd "$CURRENT_DIR"
