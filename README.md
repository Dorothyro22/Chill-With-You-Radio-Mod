<div align="center">
  <a href="https://github.com/coonlink">
    <img width="90px" src="https://raw.coonlink.com/cloud/Chill%20with%20You%20Lo-Fi%20Story.png" alt="Logo" />
  </a>
  <h1>Chill with You : Lo-Fi Story — Radio Mod</h1>

[![English](https://img.shields.io/badge/lang-English%20🇺🇸-white)](README.md)
[![Русский](https://img.shields.io/badge/язык-Русский%20🇷🇺-white)](README.ru.md)

<img alt="last-commit" src="https://img.shields.io/github/last-commit/crc137/Chill-With-You-Radio-Mod?style=flat&amp;logo=git&amp;logoColor=white&amp;color=0080ff" style="margin: 0px 2px;">
<img alt="repo-top-language" src="https://img.shields.io/github/languages/top/crc137/Chill-With-You-Radio-Mod?style=flat&amp;color=0080ff" style="margin: 0px 2px;">
<img alt="repo-language-count" src="https://img.shields.io/github/languages/count/crc137/Chill-With-You-Radio-Mod?style=flat&amp;color=0080ff" style="margin: 0px 2px;">
<img alt="version" src="https://img.shields.io/badge/version-26.1.1-blue" style="margin: 0px 2px;">
</div>

<br />

<div align="center">
  <p>Adds working <b>internet radio</b> to the game. Station switching works without stuttering.</p>
</div>

## Requirements

For the radio to work you need **all** of these:

1. The game **Chill with You : Lo-Fi Story** (any version, Steam).
2. **BepInEx 5.x** installed into the game folder
   → `...Chill with You Lo-Fi Story/BepInEx/`
   (download from `https://github.com/BepInEx/BepInEx/releases`, take `BepInEx_x64_5.4.x`).
3. The plugin file `RadioStreamPlugin.dll` (this mod).
4. Internet connection (radio streams are live online).


## How to install (player, no build needed)

1. Install the game via Steam and launch it **once** so folders are created.
2. Put **BepInEx 5.x** into the game folder:
   - Windows: `...Chill with You Lo-Fi Story/BepInEx/`
   - Steam Deck / Linux (Flatpak):
     `~/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Chill with You Lo-Fi Story/BepInEx/`
3. Copy **both** files from this repo into the **plugins** folder:
   ```
   BepInEx/plugins/RadioStreamPlugin.dll     ← the mod
   BepInEx/plugins/radiostations.txt         ← station list
   ```
4. Launch the game. In the music menu, switch stations with **J / K**.

If the station list is missing, the plugin creates a default one on first run.



## How to configure stations

`radiostations.txt` — one station per line, format:

```
Name|URL
```

Example:

```
Lo-Fi Beats|http://example.com/lofi.mp3
Jazz Radio|http://example.com/jazz.pls
```

Edit the file, then **restart the game** for changes to apply. Stations play only if the URL is reachable (some `.pls`/`.m3u` links need the browser first — prefer direct `.mp3`/`.aac` links).



## Controls

| Key | Action |
|---|---|
| **J** | Previous station |
| **K** | Next station |



## Troubleshooting

- **No radio in menu / no music** → BepInEx is not installed or the DLL is not in `BepInEx/plugins`. Make sure `BepInEx/core` exists.
- **Station doesn't play** → URL unreachable or unsupported format. Replace it in `radiostations.txt` with a direct stream link.
- **No BepInEx console** → add `[Logging.Console] Enabled = true` in `BepInEx/config/BepInEx.cfg`.



## Build from source (developers)

Requires .NET SDK (>= 6) and `build.sh` (finds the game on Linux / Windows automatically, compiles and copies the DLL). Run:

```bash
./build.sh
```
