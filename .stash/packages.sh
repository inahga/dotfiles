#!/bin/bash

sudo dnf install -y \
	krita libreoffice golang g++ mozilla-ublock-origin mozilla-https-everywhere \
	kakoune gnome-tweak-tool ShellCheck moreutils gcc pass \
	ripgrep podman ccls npm flex bison bear ansible clang-tools-extra alacritty \
	git-crypt entr cppcheck pylint python3-language-server ImageMagick libvirt-client \
	virt-manager fd-find clang socat valgrind wl-clipboard aspell aspell-en

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y com.discordapp.Discord org.signal.Signal com.spotify.Client com.obsproject.Studio
