#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
desktop_dir="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
desktop_file="$desktop_dir/dev.sam.sqgitemplate.desktop"

mkdir -p "$desktop_dir"

cat >"$desktop_file" <<EOF
[Desktop Entry]
Type=Application
Name=SQGI Template
Exec=sqgi "$repo_dir/main.nut"
Icon=$repo_dir/assets/dev.sam.sqgitemplate.png
StartupNotify=true
StartupWMClass=dev.sam.sqgitemplate
Categories=Utility;
Terminal=false
EOF

chmod 0644 "$desktop_file"

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$desktop_dir" >/dev/null 2>&1 || true
fi

echo "Installed $desktop_file"
