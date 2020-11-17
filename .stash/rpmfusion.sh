#!/bin/bash
FEDORA_VER=$(cat /etc/redhat-release | grep -o '[0-9]*')

sudo dnf install \
	https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$FEDORA_VER.noarch.rpm \
	https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$FEDORA_VER.noarch.rpm

sudo dnf install compat-ffmpeg28
