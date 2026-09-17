#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "[1/5] cleaning obj/bin"
rm -rf obj bin

GAME_DIR=""
for base in \
  "$HOME/.steam/steam/steamapps/common" \
  "$HOME/.local/share/Steam/steamapps/common" \
  "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common" \
  "$HOME/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/common" \
  "/mnt/c/Program Files (x86)/Steam/steamapps/common" \
  "/c/Program Files (x86)/Steam/steamapps/common" \
  "/opt/steam/steamapps/common" \
  "/var/lib/flatpak/steam/steamapps/common"; do
  if [ -d "$base" ]; then
    hit=$(find "$base" -maxdepth 1 -type d -iname "*Chill with You*Lo-Fi*" 2>/dev/null | head -1)
    if [ -n "$hit" ]; then GAME_DIR="$hit"; break; fi
  fi
done

if [ -z "$GAME_DIR" ] || [ ! -d "$GAME_DIR/BepInEx" ]; then
  echo "DEPLOY_SKIP: no game dir found (build done, deploy skipped)"
  echo "[3/5] restore" && TERM=vt100 dotnet restore
  echo "[4/5] build"   && TERM=vt100 dotnet build -c Release
  exit 0
fi

REFS="$(pwd)/refs"
mkdir -p "$REFS"
cp -f "$GAME_DIR/BepInEx/core/BepInEx.dll"          "$REFS/"
cp -f "$GAME_DIR/BepInEx/core/0Harmony.dll"         "$REFS/"
MANAGED="$GAME_DIR/Chill With You_Data/Managed"
cp -f "$MANAGED/Assembly-CSharp.dll"                "$REFS/"
for dll in \
  UnityEngine \
  UnityEngine.CoreModule \
  UnityEngine.AudioModule \
  UnityEngine.UnityWebRequestModule \
  UnityEngine.UnityWebRequestAudioModule \
  AudioManager \
  System.Net.Http; do
  cp -f "$MANAGED/$dll.dll" "$REFS/"
done

echo "[3/5] restore"
TERM=vt100 dotnet restore

echo "[4/5] build"
TERM=vt100 dotnet build -c Release

echo "[5/5] deploy -> $GAME_DIR/BepInEx/plugins"
PLUGIN_DIR="$GAME_DIR/BepInEx/plugins"
mkdir -p "$PLUGIN_DIR"
cp -f bin/Release/net472/RadioStreamPlugin.dll "$PLUGIN_DIR/"
echo "DEPLOY_OK"