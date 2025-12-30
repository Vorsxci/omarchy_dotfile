# omarchy_dotfile
All of my custom configs and such for my omarchy system.
Just a couple of notes about how Omarchy manages various things:

All bindings are managed in:
/home/kazuki/.local/share/omarchy/config/hypr/bindings.conf
/home/kazuki/.local/share/omarchy/default/hypr/bindings.conf
/home/kazuki/.config/hypr/bindings.conf

Those are the app-related bindings. For system menu bindings, such as theme menu
or omarchy menu, they are stored in ~/.local/share/omarchy/default/hypr/bindings/,
specifically utilities.conf.

HOWEVER, ALL bindings present within the ~/.local directory can overridden if
the same key combination is used in ~/.config/omarchy/hypr/bindings.conf file is made,
or if ~/.local/share/omarchy/config directory is supercedent in the same way

WARNING: All things in the ~/.local/share/omarchy directory is overridden by git pull


If things are running twice, make sure to check the custom ~/.config/hypr directory
and compare to ~/.local/share/omarchy/default/hypr directory! If files with duplicate
executions are present, ONLY edit the custom directory!

----------------------------------------------------------------------------------------
If custom themes not showing up in omarchy theme menu (walker), check by running "omarchy-theme-list"
It is sourced from ~/.config/omarchy/themes/, which has symlinks for the default themes sourced from
~/.local/share/omarchy/themes/
The menu in walker is propagated by an elephant lua script ~/.local/share/omarchy/default/elephant/omarchy_themes.lua
if custom themes don't show up in this menu, even though they are present in omarchy-theme-list, then make sure 
that the custom theme folder has a "preview.png" image. The lua scripts filters out themes that do not have this.

---------------------------------------------------------------------------------------

New Omarchy updates have moved custom Omarchy-related shenanigans to ~/.local/share/omarchy/config!
Be careful of having extra, overlapping files or directories within ~/.config/omarchy/, as they may result in
duplicate processes or broken executions!
12/25/25 - Moved all lines from ~/.config/omarchy/hypr/autostart.conf to ~/.local/share/omarchy/config/hypr/autostart.conf,
which will handle custom autostart things going forward. Kept old autostart.conf just in case future omarchy updates are weird.

-------------------------------------------------------------------------------------------
If omarchy-theme-set does not properly sync SDDM, change bg, etc and if omarchy-theme-bg-next is not properly working
when keybind(s) are pressed after Omarchy updates, make sure to copy paste the custom scripts in ~/.config/omarchy/customscripts/
into ~/.local/share/omarchy/bin/!

----------------------------------------------------------------------------------------------
Waybar configs are stored in ~/.config/waybar, use style.css and config.jsonc!
Scripts sourced for custom modules are in ~/.config/waybar/scripts/
12/28 - Themes themselves now handle background, chip appearance, etc internally

-------------------------------------------------------------------------------------------
Walker configuration now lives inside of ~/.config/walker, with /themes/ handling all of the customization in appearance. Just modify the
style.css file within the theme folder, and make sure that theme is declared for use in ~/.config/walker/config.toml

-----------------------------------------------------------------------------------------------
All files in ~/.config that I care about are now symlinked to gh via stow. Script to "autosync"
is dotfile-update-from-git.sh! It will autogen .bak files if they do not exist, before adopting changes.
Beware of breakage (this is why have baks...because baby got bak)

