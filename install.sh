#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[OK]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[ERR]${NC} $*"; }

MOD_DLL="RadioStreamPlugin.dll"
MOD_STATIONS="radiostations.txt"

if [ ! -f "$MOD_DLL" ]; then
  err "Файл $MOD_DLL не найден рядом со скриптом."
  err "Скачайте релиз или соберите: ./build.sh"
  exit 1
fi

echo "=== Chill with You : Lo-Fi Story — Radio Mod Installer ==="
echo ""

GAME_DIR="${GAME_DIR:-}"
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

if [ -z "$GAME_DIR" ]; then
  err "Игра не найдена автоматически."
  echo ""
  echo "Если игра установлена в нестандартное место, укажите путь вручную:"
  read -r -p "Путь к папке игры (Enter — отмена): " GAME_DIR || true
  GAME_DIR="${GAME_DIR//\~/$HOME}"
  if [ -z "$GAME_DIR" ]; then
    err "Путь не указан. Отменено."
    exit 1
  fi
  if [ ! -d "$GAME_DIR" ]; then
    err "Папка не найдена: $GAME_DIR"
    exit 1
  fi
fi

ok "Игра найдена: $GAME_DIR"

if [ ! -d "$GAME_DIR/BepInEx/core" ]; then
  err "BepInEx не установлен в папке игры."
  echo ""
  echo "  1. Скачайте BepInEx 5.x: https://github.com/BepInEx/BepInEx/releases"
  echo "     (берите BepInEx_x64_5.4.x.zip)"
  echo "  2. Распакуйте в папку игры: $GAME_DIR/"
  echo "  3. Запустите игру один раз, затем запустите этот скрипт снова."
  exit 1
fi

ok "BepInEx найден"

PLUGINS="$GAME_DIR/BepInEx/plugins"
mkdir -p "$PLUGINS"

cp -f "$MOD_DLL" "$PLUGINS/"
ok "Установлен: $MOD_DLL -> $PLUGINS/"

if [ -f "$MOD_STATIONS" ]; then
  cp -f "$MOD_STATIONS" "$PLUGINS/"
  ok "Установлен: $MOD_STATIONS -> $PLUGINS/"
fi

echo ""
echo -e "${GREEN}=== Установка завершена! ===${NC}"
echo "Запустите игру. В меню музыки переключайте станции клавишами J / K."
