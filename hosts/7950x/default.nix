{ config, pkgs, ... }:
let hostName = "7950x";
in {
  system.stateVersion = "23.05";
  networking.hostName = hostName;

  imports = [ ../../system ../../home ./amd.nix ./hardware-configuration.nix ];
}
