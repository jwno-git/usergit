# ZSH Config File
PROMPT='%F{240}%/ %F{49}>%f '

# Path
export PATH="$HOME/.local/scripts:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"

# Aliases
alias ff="fastfetch --logo-type chafa --logo "/$HOME/Pictures/Logos/debianlogo.png" --logo-padding-top 2 --logo-padding-left 2 --color-keys magenta --title-color-user 36 --title-color-host magenta"
alias hyp="Hyprland"

# Plugins
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-completions/zsh-completions.zsh

fbset -g 2880 1800 2880 1800 32
clear
ff
