{ config, pkgs, ... }:
let
  hostName = "t480";
in
{
  imports = [ ../../system ../../home ./intel.nix ./hardware-configuration.nix ];

  system.stateVersion = "23.05";
  networking.hostName = hostName;

  services.tlp.enable = true;
  services.throttled.enable = true;
  services.fstrim.enable = true;

  custom.hidpi = false;
}
