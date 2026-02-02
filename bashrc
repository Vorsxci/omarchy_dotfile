# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc
source ~/.aliases
alias vim="nvim"
# Add your own exports, aliases, and functions here.
export PATH="$HOME/.config/omarchy/customscripts:$PATH"

#export GTK_IM_MODULE=fcitx5
#export QT_IM_MODULE=fcitx5
export XMODIFIERS="@im=fcitx5"


fastfetch

# Make an alias for invoking commands you use constantly
# alias p='python'

