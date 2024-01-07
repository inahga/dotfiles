{lib, ...}:
with lib; let
  home-manager =
    builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in {
  imports = [(import "${home-manager}/nix-darwin")];

  config = {
    users = {
      users = {
        "inahga" = {
          name = "inahga";
          home = "/Users/inahga";
        };
        "inahga-work" = {
          name = "inahga-work";
          home = "/Users/inahga-work";
        };
      };
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users = {
        inahga = mkMerge [
          {
            home.stateVersion = "23.11";
            programs.git.userEmail = "inahga@gmail.com";
          }
          (import ./darwin-config.nix)
        ];
        inahga-work = mkMerge [
          {
            home.stateVersion = "23.11";
            programs.git.userEmail = "inahga@divviup.org";
          }
          (import ./darwin-config.nix)
        ];
      };
    };
  };
}
