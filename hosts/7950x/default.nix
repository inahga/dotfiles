{
  config,
  pkgs,
  ...
}: let
  hostName = "7950x";
in {
  system.stateVersion = "23.05";
  networking.hostName = hostName;

  custom.email = "inahga@divviup.org";

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_1.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
        sha256 = "qvgmG1Uci3a4HquHgLRG6IzqTVUa5ResOpstvb04HtM=";
      };
      version = "6.1.42";
      modDirVersion = "6.1.42";
      kernelPatches = [];
    };
  });

  imports = [../../system ../../home ./amd.nix ./hardware-configuration.nix];
}
