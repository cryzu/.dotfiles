# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Linux desktop dotfiles repo (Hyprland/Wayland) managed with [dotter](https://github.com/SuperCuber/dotter). Config files under version control are Handlebars templates; dotter renders them with theme variables and symlinks/copies them into `~/.config`. There is no build or test suite. Branch `dev-lua-rework` is for migrating Hyprland config from hyprlang to Lua (hyprlang support for Hyprland <= 0.54 was deprecated in the init commit).

## Commands

- Deploy (render templates + link into `~/.config`): `cd ~/.dotfiles && dotter deploy -f` (overwrites existing targets)
- Switch theme and reload programs: `scripts/switch-theme.sh <theme-name>` (no args lists themes). It copies `.dotter/themes/<name>.toml` to `.dotter/theme.toml`, redeploys, then kills/restarts hyprpaper, waybar, dunst, firefox, dolphin and ghostty. It is also bound to a rofi picker (`scripts/rofi-theme-selector.sh`, Super+Shift+Space).

## Architecture

- `.dotter/global.toml` — maps each repo directory to its `~/.config/...` target (`[default.files]`) and registers the `color_conv` helper. Add a new app's config by adding a mapping here. Note the firefox target is a hardcoded profile path.
- `.dotter/themes/*.toml` — each defines `[theme.variables]` (colors like `foreground`, `accent`, `palette_*` as `#rrggbbaa`, plus `font-family`, `rounding`, `gaps`, `wallpaper`, `qt_theme`). All themes must define the same variable set, since templates reference them.
- `.dotter/theme.toml` — the *active* theme, a copy of one of the theme files; gitignored, as are `.dotter/local.toml` and `.dotter/cache*`. `local.toml` (per-machine) includes `.dotter/theme.toml` and selects packages `["default", "theme"]`.
- `.dotter/helpers/color_conv.rhai` — Rhai helper used in templates as `{{ color_conv <var> "<mode>" }}`. Converts `#rgb/#rgba/#rrggbb/#rrggbbaa` to modes: `hex` (alpha stripped), `rgb`, `rgba`, `hsl`, `hsla`, or single channels `r g b a h s l`. Use it for formats each app expects (e.g. `hypr/theme.conf` uses `rgb`/`rgba` for borders).
- App config dirs (`hypr/`, `waybar/`, `rofi/`, `dunst/`, `ghostty/`, `btop/`, `gtk/`, `firefox/`, `equibop/`, `Code/User/settings.json`, `uwsm/`, `autostart/`) hold the templates. Theme-dependent values use `{{variable}}`. Waybar is configured by `waybar/config.jsonc` and `waybar/style.css` (themed), plus helper scripts in `waybar/modules/`.
- `hypr/hyprland.conf` is the entry point that `source`s the split files (monitors, programs, rules, keybinds, input, appearance, theme). `hypr/defaults/` holds stock reference configs.
- `scripts/` — helper shell scripts deployed to `~/.config/scripts` and invoked from keybinds/waybar (volume, brightness, mic, popups, system update, theme switching).
- `dotter-rs-bin/` — a separate git repo containing an AUR PKGBUILD for dotter, not part of the dotfiles.

## Conventions

- **Commit messages**: `<Type>: <description>`, e.g. `Feat: Added vscode support`. Types seen so far: `Init`, `Feat`; use `Fix`, `Refactor`, `Docs`, `Chore` etc. in the same capitalized style.
- **Paths must be machine-independent**: use Arch Linux default install locations (`/usr/bin`, `/usr/share`, `/etc`, ...) for system paths. Never hardcode a username or `/home/<user>`; use `~`, `$HOME`, or a Handlebars variable defined in `local.toml`/the theme files. Note that Hyprland `.conf` files don't expand `$HOME`, so use `~` or a template variable there.
- Known existing violations to fix when touched: `/home/cryzu/...` in `hypr/hyprqt6engine.conf`, `hypr/environment.conf`, `uwsm/env-hyprland`, and the hardcoded Firefox profile id in `.dotter/global.toml`. Move the Firefox profile into a per-machine variable in `local.toml`.
- **Remove unused files**: anything not deployed or referenced (reference copies, old layouts) should be deleted rather than kept around. Git history is the archive.
- **Rounding, gaps and fonts are part of the theme**: they stay in each `.dotter/themes/*.toml` alongside colors. Only genuinely non-theme values (see below) go elsewhere.

## Planned direction

- **Per-machine values go in `.dotter/local.toml`** under `[variables]` (gitignored): Firefox profile id, monitor layout, screenshot dir, and other things that differ between machines. Templates reference them like theme variables. Not yet migrated.
- **Theme consistency check**: a script should verify every `.dotter/themes/*.toml` defines the same `[theme.variables]` keys, since a missing key only fails at render time. Not yet written.
- **Theme switching should not kill user apps**: `switch-theme.sh` currently kills Firefox, Dolphin and Ghostty, which can lose work. Prefer live reload (waybar, dunst, hyprpaper) and make restarting the others opt-in.
- **Hyprland Lua rework**: on hold, to be planned separately.

## Gotchas

- Because deployed files are rendered from templates, edit the repo files, not `~/.config`, then redeploy. Literal `{{` in a config (e.g. waybar/JSON/CSS) must be escaped for Handlebars.
- Adding a theme variable means adding it to every file in `.dotter/themes/`.
- `.gitignore` whitelists only specific files in `Code/` and `equibop/`; check it before adding files there.
