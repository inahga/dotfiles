{ config, pkgs, ... }:
let hostName = "t14";
in {
  system.stateVersion = "23.05";
  networking.hostName = hostName;

  hardware.cpu.amd.updateMicrocode = true;
  boot.kernelParams = [ "acpi_backlight=native" ];

  imports = [ ../../system ../../home ./amd.nix ];
}
