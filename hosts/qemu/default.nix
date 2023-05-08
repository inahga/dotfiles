{ config, pkgs, ... }:
let hostName = "qemu";
in {
  system.stateVersion = "23.05";
  networking.hostName = hostName;
  imports = [ ../../system ../../home ];
}
