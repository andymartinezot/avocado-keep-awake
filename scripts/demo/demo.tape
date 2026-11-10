# Records docs/avocado-keep-awake-demo.gif with the real panel, a stand-in herdr
# (scripts/demo/herdr: one agent working) and a throwaway mode dir.
# Run from the repo root: vhs scripts/demo/demo.tape   (brew install vhs)

Output docs/avocado-keep-awake-demo.gif

Set Shell zsh
Set FontSize 16
Set Width 600
Set Height 345
Set Padding 14
Set Theme "Dracula"
Set TypingSpeed 60ms
Set CursorBlink false

Hide
Type "export HERDR_PLUGIN_CONFIG_DIR=$(mktemp -d) HERDR_BIN_PATH=$PWD/scripts/demo/herdr AVOCADO_KEEP_AWAKE_THEME=dracula; unset HERDR_ENV; demo() { clear; zsh bin/avocado-keep-awake panel; }; demo"
Enter
Sleep 1.5s
Show

# Agent mode (the default): awake, because an agent is working.
Sleep 3s

# Off: normal sleep.
Down
Sleep 900ms
Enter
Hide
Type "demo"
Enter
Sleep 1.2s
Show
Sleep 2.5s

# On, with a number key.
Type "1"
Hide
Type "demo"
Enter
Sleep 1.2s
Show
Sleep 2.5s

# Back to Agent.
Down
Sleep 900ms
Enter
Hide
Type "demo"
Enter
Sleep 1.2s
Show
Sleep 3s

# Close, and release caffeinate so the recording leaves nothing running.
Escape
Hide
Type "zsh bin/avocado-keep-awake off"
Enter
Sleep 500ms
