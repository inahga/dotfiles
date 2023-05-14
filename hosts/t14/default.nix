{ config, pkgs, ... }:
let hostName = "t14";
in {
  system.stateVersion = "23.05";
  networking.hostName = hostName;

  boot.kernelParams = [ "acpi_backlight=native" ];
  services.tlp.enable = true;

  imports = [ ../../system ../../home ./amd.nix ./hardware-configuration.nix ];
}
