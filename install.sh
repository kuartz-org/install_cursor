#! /bin/bash

response=$(curl -X POST https://www.cursor.com/api/dashboard/get-download-link -H "Content-Type: application/json" -d '{"platform": 5}')

download_link=$(echo $response | jq -r '.cachedDownloadLink')

curl -L $download_link -o ~/.local/cursor-latest.AppImage

chmod +x ~/.local/cursor-latest.AppImage

curl -L https://raw.githubusercontent.com/kuartz-org/install_cursor/refs/heads/main/launch_cursor.sh -o ~/.local/bin/launch_cursor.sh

chmod +x ~/.local/bin/launch_cursor.sh

echo "alias cursor='~/.local/bin/launch_cursor.sh'" >> ~/.zshrc

echo "Cursor installed successfully."
echo "Use 'cursor' command to launch Cursor and forget 'code' command!"
