# .bashrc

source ~/.shrc

export LS_COLORS='rs=0:di=33:ln=38;5;51:mh=00:pi=40;38;5;11:so=38;5;13:do=38;5;5:bd=48;5;232;38;5;11:cd=48;5;232;38;5;3:or=48;5;232;38;5;9:mi=01;37;41:su=48;5;196;38;5;15:sg=48;5;11;38;5;16:ca=48;5;196;38;5;226:tw=48;5;10;38;5;16:ow=48;5;10;38;5;21:st=48;5;21;38;5;15:ex=38;5;40'

export PS1="\n\e[36m[\!]\e[0m \
\$(if [ \$? == 0 ]; then echo \[\e[32m\]:\)\[\e[0m\]; else echo \[\e[31m\]:\(\[\e[0m\]; fi) \
\w\$(if [ -e ~/.git-prompt ]; then __git_ps1 \" (git: %s)\"; fi)\n\$ "

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
	PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
