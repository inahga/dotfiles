#!/bin/bash
# See https://www.atlassian.com/git/tutorials/dotfiles

git clone --bare git@github.com:inahga/dotfiles.git "$HOME/.cfg"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
cd $HOME
config checkout
config config --local status.showUntrackedFiles no
