#!/usr/bin/env bash
set -xe

nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
nix-channel --add https://nixos.org/channels/nixpkgs-23.11-darwin nixpkgs
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
