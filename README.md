# Cryzu's dotfile repository

Uses dotter, rhai and bash scripts to apply themes globally.
As lightweight and configurable as possible.

### Dependencies:
Strict:
* [dotter](https://github.com/SuperCuber/dotter)

Optional (pre-themed):
* hyprland
* hyprpaper
* waybar
* visual-studio-code-bin
* dunst
* rofi
* equibop
* ghostty

## Installation 
### Arch:
1. Install dotter from AUR
```
yay -Sy dotter
```

2. Clone this repo (preferrably to the home directory):
```
cd ~
git clone git@github.com:cryzu/.dotfiles.git
```

3. Add file local.toml to .dotter directory with the following content:
```
cd ~/.dotfiles/.dotter
touch local.toml
nano local.toml
```
```
includes = [".dotter/theme.toml"]
packages = ["default", "theme"]
```

4. Deploy dotter:
> [!WARNING]
> This will overwrite the matching files in your ~/.config directory to make symlinks!

```
cd ~/.dotfiles
dotter deploy -f
```

## Usage

* Change themes with Super + Shift + Space (If rofi is installed)
* Add themes by making a new .toml file in .dotfiles/.dotter/themes (use the existing ones as a template)
* Add the theme to new packages by using handlebars (use existing configs as reference), reload the program by editing .dotfiles/scripts/switch-theme.sh if necessary