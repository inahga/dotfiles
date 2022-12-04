# .bashrc 
source ~/.shrc

export GLADMOJI="😀😅😆😄😃😇😉😊🙂😋😍😘😜😝😛😎😏😻😺🙌💪👌🌞🔥👍💕💯✅🆒🆗💲"
export SADMOJI="😶😳😠😞😡😕😣😖😫😩😮😱😨😰😯😦😢😥😥😵😭😴😷💀😿👎🙊💥🔪💔🆘⛔🚫❌🚷❓❗"
export PROMPT_DIRTRIM=3
export PS1="\n\e[36m\u@\h\[\e[0m\] \
\$(if [ \$? == 0 ]; then echo -n \"\${GLADMOJI:RANDOM%\${#GLADMOJI}:1}\"; \
else echo -n \"\${SADMOJI:RANDOM%\${#SADMOJI}:1}\"; fi)\
\$(if [ -e ~/.git-prompt ]; then __git_ps1 \" (git: %s)\"; fi) \w\n🐧 "

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
	PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH="$PATH:$HOME/go/bin"

if [ -e "$HOME/.cargo/env" ]; then
	. "$HOME/.cargo/env"
fi
