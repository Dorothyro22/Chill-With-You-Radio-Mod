<div align="center">
  <a href="https://github.com/coonlink">
    <img width="90px" src="https://raw.coonlink.com/cloud/Chill%20with%20You%20Lo-Fi%20Story.png" alt="Logo" />
  </a>
  <h1>Chill with You : Lo-Fi Story — Мод «Радио»</h1>

[![English](https://img.shields.io/badge/lang-English%20🇺🇸-white)](README.md)
[![Русский](https://img.shields.io/badge/язык-Русский%20🇷🇺-white)](README.ru.md)

<img alt="last-commit" src="https://img.shields.io/github/last-commit/crc137/Chill-With-You-Radio-Mod?style=flat&amp;logo=git&amp;logoColor=white&amp;color=0080ff" style="margin: 0px 2px;">
<img alt="repo-top-language" src="https://img.shields.io/github/languages/top/crc137/Chill-With-You-Radio-Mod?style=flat&amp;color=0080ff" style="margin: 0px 2px;">
<img alt="repo-language-count" src="https://img.shields.io/github/languages/count/crc137/Chill-With-You-Radio-Mod?style=flat&amp;color=0080ff" style="margin: 0px 2px;">
<img alt="version" src="https://img.shields.io/badge/version-26.1.1-blue" style="margin: 0px 2px;">
</div>

<br />

<div align="center">
  <p>Добавляет в игру <b>рабочее интернет-радио</b>. Переключение станций — без заикания.</p>
</div>

## Требования

Чтобы радио заработало, нужно **всё** из списка:

1. Игра **Chill with You : Lo-Fi Story** (любая версия, Steam).
2. **BepInEx 5.x**, установленный в папку игры
   → `...Chill with You Lo-Fi Story/BepInEx/`
   (скачать тут: `https://github.com/BepInEx/BepInEx/releases`, брать `BepInEx_x64_5.4.x`).
3. Файл плагина `RadioStreamPlugin.dll` (этот мод).
4. Интернет (радио играет вживую из сети).



## Как установить (игроку, сборка не нужна)

**Вариант A — установщик в один клик (рекомендую)**

Положите `install.sh`, `install.bat`, `RadioStreamPlugin.dll` и `radiostations.txt` в одну папку и запустите установщик для своей ОС:

- **Windows:** двойной клик по `install.bat`
- **Linux / Steam Deck:** `./install.sh`

Установщик сам найдёт игру, проверит BepInEx и скопирует мод в `BepInEx/plugins`. Если игра стоит в нестандартном месте — спросит путь вручную. BepInEx по-прежнему нужно поставить один раз (см. ниже).

**Вариант B — вручную**

1. Установите игру через Steam и **один раз** запустите её, чтобы создались папки.
2. Положите **BepInEx 5.x** в папку игры:
   - Windows: `Chill with You Lo-Fi Story/BepInEx/`
   - Steam Deck / Linux (flatpak):
     `~/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Chill with You Lo-Fi Story/BepInEx/`
3. Скопируйте **оба** файла из этого репозитория в папку **plugins**:
   ```
   BepInEx/plugins/RadioStreamPlugin.dll     ← сам мод
   BepInEx/plugins/radiostations.txt         ← список станций
   ```
4. Запустите игру, откройте меню музыки и переключайте станции клавишами **J / K**.

Если файла со станциями нет — плагин сам создаст стандартный при первом запуске.



## Как настроить станции

`radiostations.txt` — по одной станции на строку, формат:

```
Название|URL
```

Пример:

```
Lo-Fi Beats|http://example.com/lofi.mp3
Jazz Radio|http://example.com/jazz.pls
```

Измените файл и **перезапустите игру** — новые станции подхватятся. Радио играет только если адрес станции доступен (для некоторых `.pls`/`.m3u` нужен браузер — лучше вставлять прямые ссылки на `.mp3`/`.aac`).



## Управление

| Клавиша | Действие |
|---|---|
| **J** | Предыдущая станция |
| **K** | Следующая станция |


## Если не работает

- **Нет радио в меню / нет музыки** → проверьте, что BepInEx реально установлен (в папке игры должна быть `BepInEx/core`) и DLL лежит в `BepInEx/plugins`.
- **Станция не играет** → адрес недоступен или формат не поддерживается. Замените её в `radiostations.txt` на прямую ссылку потока.
- **Не видно консоли BepInEx** → в `BepInEx/config/BepInEx.cfg` включите `[Logging.Console] Enabled = true`.

## Сборка из исходников (для разработчиков)

Нужен .NET SDK (>= 6) и скрипт `build.sh` (сам находит игру на Linux / Windows, собирает и копирует DLL). Запуск:

```bash
./build.sh
```
