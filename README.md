# NoAddonsRun

A World of Warcraft **Classic Era** addon for guilds that play without addons.

Ironically, it's the only addon you're allowed to have: it detects which other addons each player has loaded and shows guild members who also run NoAddonsRun who is breaking the rule.

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
  - Hover → number of online rule breakers.
  - The icon turns **red** when you or an online guild member is breaking the rule.
- **Window** shows your own proof at the top (works without a guild):
  - Green **PLAYING WITHOUT ADDONS**, or red **ADDONS LOADED** with the list.
- Below, if you're in a guild, it lists online guild members:
  - Red: breaks the rule (shows their addons).
  - Gray: doesn't have NoAddonsRun (unknown).
  - Green: clean.
  - **Check guild** button asks everyone to report again.
- **Slash commands**: `/noaddons` or `/nar` toggle the window.

## How it works

- On login, each player sends the list of addons they have loaded over a hidden guild addon channel, and asks everyone else to report.
- Blizzard's own addons (`Blizzard_*`) and NoAddonsRun itself are ignored.
- Nothing is posted to chat.

## Limitations

- **Honor system.** Anyone can edit the Lua code to always report "clean". The game doesn't let one client inspect another's addons, so no addon can prevent this.
- Players without NoAddonsRun can't be checked; they show as "unknown".
- Load-on-demand addons that load after login only show up on the next check.
