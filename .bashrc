# .bashrc
source ~/.shrc

export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
export HISTFILE=~/.bash_eternal_history
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

__kube_ps1() {
	CONTEXT=$(cat ~/.kube/config | grep "current-context:" | sed "s/current-context: //" | cut -f1 -d'/')
	if [ -n "$CONTEXT" ]; then
		echo "(k8s: ${CONTEXT})"
	fi
}

export GLADMOJI="😀😅😆😄😃😇😉😊🙂😋😍😘😜😝😛😎😏😻😺🙌💪👌🌞🔥👍💕💯✅🆒🆗💲"
export SADMOJI="😶😳😠😞😡😕😣😖😫😩😮😱😨😰😯😦😢😥😥😵😭😴😷💀😿👎🙊💥🔪💔🆘⛔🚫❌🚷❓❗"
export PROMPT_DIRTRIM=3
export PS1="\n\e[36m\u\[\e[0m\] \
\$(if [ \$? == 0 ]; then echo -n \"\${GLADMOJI:RANDOM%\${#GLADMOJI}:1}\"; \
else echo -n \"\${SADMOJI:RANDOM%\${#SADMOJI}:1}\"; fi) \
\$(__kube_ps1)\$(if [ -e ~/.git-prompt ]; then __git_ps1 \" (git: %s)\"; fi) \w\n🐧 "

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

# added by travis gem
[ ! -s /home/aghani/.travis/travis.sh ] || source /home/aghani/.travis/travis.sh
