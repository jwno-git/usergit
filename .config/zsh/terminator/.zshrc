# ZSH Config File
PROMPT='%F{49} >%f '

# Path
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"

# Aliases
alias ff="fastfetch --logo none --color-keys magenta --title-color-user 36 --title-color-host magenta"
alias hyp="Hyprland"

# Plugins
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

fbset -g 2880 1800 2880 1800 32
clear
ff
