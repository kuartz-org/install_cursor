#! /bin/bash

CURRENT_DIR=`pwd`

cd /tmp

curl -L --output cursor.appimage https://downloader.cursor.sh/linux/x64
sudo mv cursor.appimage /opt/cursor.appimage
sudo chmod +x /opt/cursor.appimage
sudo apt install -y fuse3
sudo apt install -y libfuse2t64

DESKTOP_FILE="/usr/share/applications/cursor.desktop"

sudo bash -c "cat > $DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=Cursor
Comment=AI-powered code editor
Exec=/opt/cursor.appimage --no-sandbox
Icon=/home/$USER/.local/share/omakub/applications/icons/cursor.png
Type=Application
Categories=Development;IDE;
EOL

if [ -f "$DESKTOP_FILE" ]; then
  echo "cursor.desktop created successfully"
else
  echo "Failed to create cursor.desktop"
fi

if [ ! -d "~/.local/bin/launch_cursor" ]; then
  curl -L https://raw.githubusercontent.com/kuartz-org/install_cursor/refs/heads/main/launch_cursor.sh -o ~/.local/bin/launch_cursor
  chmod +x ~/.local/bin/launch_cursor
fi

if ! grep -q "alias cursor='launch_cursor ." ~/.zshrc; then
  echo "alias cursor='launch_cursor ." >> ~/.zshrc
fi

cd "$CURRENT_DIR"

echo "Cursor installed successfully."
echo "Use 'cursor' command to launch Cursor"
