@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title Chill with You : Lo-Fi Story - Radio Mod Installer

set "MOD_DLL=RadioStreamPlugin.dll"
set "MOD_STATIONS=radiostations.txt"

if not exist "%MOD_DLL%" (
  echo [ERR] File "%MOD_DLL%" not found next to this script.
  echo [ERR] Download a release or build it first.
  pause
  exit /b 1
)

echo === Chill with You : Lo-Fi Story - Radio Mod Installer ===
echo.

set "GAME_DIR="

rem 1) Steam default install path
if "%STEAM_DIR%"=="" set "STEAM_DIR=D:\SteamLibrary\steamapps\common"

for %%S in (
  "C:\Program Files (x86)\Steam\steamapps\common"
  "C:\Program Files\Steam\steamapps\common"
  "D:\SteamLibrary\steamapps\common"
  "E:\SteamLibrary\steamapps\common"
  "F:\SteamLibrary\steamapps\common"
  "G:\SteamLibrary\steamapps\common"
) do (
  if exist %%S\*Chill with You*Lo-Fi* (
    set "GAME_DIR=%%S\*Chill with You*Lo-Fi*"
    goto :found
  )
)

rem 2) scan via Steam libraryfolders.vdf
if not exist "C:\Program Files (x86)\Steam\steamapps\libraryfolders.vdf" goto :scan_done
for /f "usebackq tokens=2 delims=	" %%L in ("C:\Program Files (x86)\Steam\steamapps\libraryfolders.vdf") do (
  set "LIB=%%~L"
  if exist "!LIB!\steamapps\common\*Chill with You*Lo-Fi*" (
    set "GAME_DIR=!LIB!\steamapps\common\*Chill with You*Lo-Fi*"
    goto :found
  )
)
:scan_done

if "%GAME_DIR%"=="" (
  echo [ERR] Game not found. Install it via Steam and launch it once.
  echo.
  set /p GAME_DIR="Enter the game folder manually (or press Enter to cancel): "
  if "!GAME_DIR!"=="" (
    echo [ERR] No folder selected. Canceled.
    pause
    exit /b 1
  )
)

:found
set "GAME_DIR=%GAME_DIR%"
echo [OK] Game found: %GAME_DIR%

if not exist "%GAME_DIR%\BepInEx\core" (
  echo [ERR] BepInEx is not installed in the game folder.
  echo.
  echo  1. Download BepInEx 5.x: https://github.com/BepInEx/BepInEx/releases
  echo     ^(take BepInEx_x64_5.4.x.zip^)
  echo  2. Extract it into: "%GAME_DIR%"
  echo  3. Launch the game once, then run this script again.
  pause
  exit /b 1
)

echo [OK] BepInEx found

set "PLUGINS=%GAME_DIR%\BepInEx\plugins"
if not exist "%PLUGINS%" mkdir "%PLUGINS%"

copy /y "%MOD_DLL%" "%PLUGINS%\" >nul
echo [OK] Installed: %MOD_DLL% -^> %PLUGINS%

if exist "%MOD_STATIONS%" (
  copy /y "%MOD_STATIONS%" "%PLUGINS%\" >nul
  echo [OK] Installed: %MOD_STATIONS% -^> %PLUGINS%
)

echo.
echo [OK] === Installation complete! ===
echo Launch the game. In the music menu switch stations with J / K.
echo.
pause