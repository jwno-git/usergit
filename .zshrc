# Attempt to detect the terminal emulator
TERM_EMULATOR="${TERM_PROGRAM:-$(basename "$TERMINAL")}"

# Fallback to inspecting the parent process if needed
if [[ -z "$TERM_EMULATOR" ]]; then
    TERM_EMULATOR="$(ps -o comm= -p $(ps -o ppid= -p $$) | head -n1)"
fi

# Load terminal-specific Zsh config
if [[ "$TERM_EMULATOR" == "foot" || "$TERM_EMULATOR" == "footclient" ]]; then
    source /home/user/.config/zsh/foot/.zshrc
else
    source /home/user/.config/zsh/terminator/.zshrc
fi
