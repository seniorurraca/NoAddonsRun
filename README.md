# NoAddonsRun

A World of Warcraft **Classic Era** addon that proves you play without addons.

Ironically, it's the only addon you're allowed to have: it detects which other addons each player has loaded and shows your guild and group mates who also run NoAddonsRun who is breaking the rule.

Available in English and Spanish (follows the game client language).

## Installation

### Option 1: Download ZIP

1. Click **Code → Download ZIP** on this page.
2. Extract the ZIP. You'll get a folder named `NoAddonsRun-main`.
3. **Rename it to `NoAddonsRun`** (required, or WoW won't load it).
4. Move it into your AddOns folder:

   ```
   World of Warcraft\_classic_era_\Interface\AddOns\NoAddonsRun\
   ```

   The file `NoAddonsRun.toc` must be directly inside that folder:

   ```
   AddOns\NoAddonsRun\NoAddonsRun.toc   ✓
   AddOns\NoAddonsRun\NoAddonsRun\NoAddonsRun.toc   ✗
   ```

5. Restart the game (or `/reload` if it was already running).

### Option 2: Git

```bash
cd "World of Warcraft/_classic_era_/Interface/AddOns"
git clone https://github.com/seniorurraca/NoAddonsRun.git
```

Update later with `git pull`.

### "Out of date" warning

If the addon shows as out of date on the character screen, either:

- Check **Load out of date AddOns** in the AddOns menu, or
- Run `/dump select(4, GetBuildInfo())` in game and put that number in the `## Interface:` line of `NoAddonsRun.toc`.

## Usage

- **Minimap button** (spyglass icon):
  - Click → open the window.
  - Drag → move it around the minimap.
  - Hover → your status and number of rule breakers.
  - The icon turns **red** when you or anyone listed is breaking the rule.
- **Window** shows your own proof at the top (works without a guild or group):
  - Green **PLAYING WITHOUT ADDONS**, or red **BREAKING THE RULE** with the addons to disable.
- Below, it lists other players in three sections: **Group**, **Guild online** and **Others seen** (players met earlier this session):
  - Red: breaks the rule (shows their addons).
  - Gray: doesn't have NoAddonsRun (unknown).
  - Green: clean.
  - **Check again** button asks everyone to report again.
- **Player tooltip**: hovering over a player who runs NoAddonsRun shows their status.
- **Slash commands**: `/noaddons` or `/nar` toggle the window.

## How it works

- On login, and when joining a party or raid, each player sends the list of addons they have loaded over hidden guild and group addon channels, and asks everyone else to report.
- Blizzard's own addons (`Blizzard_*`) and NoAddonsRun itself are ignored.
- Nothing is posted to chat.

## Limitations

- **Honor system.** Anyone can edit the Lua code to always report "clean". The game doesn't let one client inspect another's addons, so no addon can prevent this.
- Players without NoAddonsRun can't be checked; they show as "unknown".
- Load-on-demand addons that load after login only show up on the next check.
- Only players in your guild or group can be checked; there's no server-wide channel.
