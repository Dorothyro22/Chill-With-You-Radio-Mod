#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "[1/6] cleaning obj/bin"
rm -rf obj bin

STEAM_APPID=3548580
GAME_EXE="Chill With You.exe"
REFS="$(pwd)/refs"

declare -a ROOTS=()

add_root() {
  local r="${1%/}"
  [ -z "$r" ] && return 0
  [ -d "$r" ] || return 0
  for x in "${ROOTS[@]:-}"; do
    [ "$x" = "$r" ] && return 0
  done
  ROOTS+=("$r")
}

add_root "$HOME/.steam/steam"
add_root "$HOME/.local/share/Steam"
add_root "$HOME/.steam/debian-installation"
add_root "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam"

for _round in 1 2 3 4; do
  changed=0
  for root in "${ROOTS[@]:-}"; do
    vdf="$root/steamapps/libraryfolders.vdf"
    [ -f "$vdf" ] || continue
    while IFS= read -r p; do
      [ -n "$p" ] || continue
      before=${#ROOTS[@]}
      add_root "$p"
      if [ "${#ROOTS[@]}" -gt "$before" ]; then changed=1; fi
    done < <(sed -nE 's/^[[:space:]]*"path"[[:space:]]+"([^"]+)".*/\1/p' "$vdf" 2>/dev/null)
  done
  [ "$changed" -eq 0 ] && break
done

for base in /run/media /media /mnt; do
  [ -d "$base" ] || continue
  while IFS= read -r f; do
    add_root "$(dirname "$(dirname "$f")")"
  done < <(find "$base" -maxdepth 8 -type f -name "appmanifest_${STEAM_APPID}.acf" 2>/dev/null)
done

is_real_game_dir() {
  local d="$1"
  [ -d "$d" ] || return 1
  [ -f "$d/$GAME_EXE" ] || [ -d "$d/Chill With You_Data" ] || ls "$d"/*_Data >/dev/null 2>&1
}

find_game_dir() {
  local root inst cand
  for root in "${ROOTS[@]:-}"; do
    inst=""
    if [ -f "$root/steamapps/appmanifest_${STEAM_APPID}.acf" ]; then
      if grep -q '"StateFlags"[[:space:]]*"4"' "$root/steamapps/appmanifest_${STEAM_APPID}.acf" 2>/dev/null; then
        inst=$(sed -nE 's/^[[:space:]]*"installdir"[[:space:]]+"([^"]+)".*/\1/p' "$root/steamapps/appmanifest_${STEAM_APPID}.acf" | head -1)
      fi
      if [ -n "$inst" ] && is_real_game_dir "$root/steamapps/common/$inst"; then
        echo "$root/steamapps/common/$inst"
        return 0
      fi
    fi
    while IFS= read -r cand; do
      if is_real_game_dir "$cand"; then
        echo "$cand"
        return 0
      fi
    done < <(find "$root/steamapps/common" -maxdepth 1 -type d -iname "*Chill with You*Lo-Fi*" 2>/dev/null)
  done
  return 1
}

GAME_DIR="$(find_game_dir || true)"

echo "[2/6] checking references"

MANAGED=""
if [ -n "$GAME_DIR" ]; then
  for d in "$GAME_DIR"/*_Data/Managed; do
    if [ -d "$d" ]; then MANAGED="$d"; break; fi
  done
fi

mkdir -p "$REFS"

gen_ref() {
  local name="$1"
  [ -f "$REFS/$name" ] && return 0
  local src=""
  case "$name" in
    BepInEx.dll|0Harmony.dll) src="$GAME_DIR/BepInEx/core/$name" ;;
    *) src="$MANAGED/$name" ;;
  esac
  if [ -n "$src" ] && [ -f "$src" ]; then
    cp -f "$src" "$REFS/"
    echo "  generated refs/$name from $src"
    return 0
  fi
  echo "ERROR: missing reference: refs/$name"
  return 1
}

required_refs=(
  "BepInEx.dll"
  "0Harmony.dll"
  "Assembly-CSharp.dll"
  "UnityEngine.dll"
  "UnityEngine.CoreModule.dll"
  "UnityEngine.AudioModule.dll"
  "UnityEngine.UnityWebRequestModule.dll"
  "UnityEngine.UnityWebRequestAudioModule.dll"
  "AudioManager.dll"
  "System.Net.Http.dll"
)

missing=0
for dll in "${required_refs[@]}"; do
  gen_ref "$dll" || missing=1
done

if [ "$missing" -eq 1 ]; then
  echo ""
  echo "ERROR: Missing references in refs/ and unable to get them from the game."
  echo "Either install the game via Steam and launch it once, or copy refs/*.dll manually."
  echo "(Alternatively, just run ./install.sh — it will collect the refs as well)."
  exit 1
fi

echo "[3/6] restore"
TERM=vt100 dotnet restore

echo "[4/6] build"
TERM=vt100 dotnet build -c Release

if [ -z "$GAME_DIR" ]; then
  echo ""
  echo "DEPLOY_SKIP: game not found (build completed, skipping copy)."
  echo "DLL: bin/Release/net472/RadioStreamPlugin.dll  (+NLayer.dll)"
  echo "Run ./install.sh to install into the game."
  exit 0
fi

echo "[5/6] deploy -> $GAME_DIR/BepInEx/plugins"

PLUGIN_DIR="$GAME_DIR/BepInEx/plugins"
mkdir -p "$PLUGIN_DIR"
cp -f bin/Release/net472/RadioStreamPlugin.dll "$PLUGIN_DIR/"
cp -f bin/Release/net472/NLayer.dll "$PLUGIN_DIR/"
echo "  RadioStreamPlugin.dll + NLayer.dll copied to $PLUGIN_DIR/"

if [ -f radiostations.txt ]; then
  cp -f radiostations.txt "$PLUGIN_DIR/"
  echo "  radiostations.txt copied"
fi

echo "[6/6] deploy OK"
echo "DEPLOY_OK"