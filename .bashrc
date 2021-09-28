# .bashrc

source ~/.shrc

export LS_COLORS='rs=0:di=33:ln=38;5;51:mh=00:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=01;37;41:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15:ex=38;5;40'

__kube_ps1() {
	CONTEXT=$(cat ~/.kube/config | grep "current-context:" | sed "s/current-context: //" | cut -f1 -d'/')
	if [ -n "$CONTEXT" ]; then
		echo "(k8s: ${CONTEXT})"
	fi
}

export GLADMOJI="😀😅😆😄😃😇😉😊🙂😋😍😘😜😝😛😎😏😻😺🙌💪👌🌞🔥👍💕💯✅🆒🆗💲"
export SADMOJI="😶😳😠😞😡😕😣😖😫😩😮😱😨😰😯😦😢😥😥😵😭😴😷💀😿👎🙊💥🔪💔🆘⛔🚫❌🚷❓❗"
export PROMPT_DIRTRIM=3
export PS1="\n\e[36m[\d \t] \u\[\e[0m\] \
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

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

if [ -e "$HOME/.cargo/env" ]; then
	. "$HOME/.cargo/env"
fi
