# ZSH Config File

# Dynamic Prompt Based on User
if [ "$(id -u)" -eq 0 ]; then
  # Root User
  PROMPT='%F{red}root%f %F{49}>%f '
else
  # Normal User
  PROMPT='%F{49} >%f '
fi

# Path
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"

# Aliases
alias ff="fastfetch --logo-type sixel --logo "/home/user/Pictures/Logos/debianlogo.png" --logo-padding-top 2 --logo-padding-left 2 --color-keys magenta --title-color-user blue"
alias hyp="Hyprland"
alias nvim="nvim -u ~/.config/nvim/init.vim"

# Plugins
source /root/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /root/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

fbset -g 2880 1800 2880 1800 32
clear
ff
