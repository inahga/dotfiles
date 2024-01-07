{ config, pkgs, ... }:

{
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "/private/etc/nix-darwin/hosts/mbp/darwin-configuration.nix";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  imports = [../../system/darwin.nix ../../home/darwin.nix];
}
