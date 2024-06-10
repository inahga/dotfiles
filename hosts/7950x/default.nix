{...}: let
  hostName = "7950x";
in {
  system.stateVersion = "23.05";
  networking.hostName = hostName;

  custom.email = "inahga@divviup.org";

  imports = [../../system ../../home ./amd.nix ./hardware-configuration.nix];
}
