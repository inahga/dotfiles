{ config, pkgs, lib, ... }: {
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.auto-optimise-store = true;
    nixPath = with config; [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/etc/nixos/hosts/${networking.hostName}/default.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  boot = {
    loader.systemd-boot.enable = true;
  };

  swapDevices = [{
    device = "/swap";
    size = 8192;
  }];

  system.autoUpgrade.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;
  hardware.bluetooth = {
    enable = true;
    settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
  };

  time.timeZone = "America/Detroit";

  users.users.inahga = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    initialPassword = "password";
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJBN1uV3RK41ghFQLYqNTVXUVALbn3KDr3E8HCxk7zC8AAAAEXNzaDp5dWJpa2V5LXNtYWxs"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHLtwflRB2PAPOAtqRpH5z7TJ/AG9iKo9pDUo/NdP0KyAAAAEXNzaDp5dWJpa2V5LXNtYWxs"
    ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.river}/bin/river";
        user = "inahga";
      };
    };
  };

  services.dbus.enable = true;
  services.flatpak.enable = true;
  services.blueman.enable = true;
  services.tlp.enable = true;
  services.fwupd.enable = true;
  services.pcscd.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.rtkit.enable = true;
  security.doas = {
    enable = true;
    extraRules = [{
      groups = [ "wheel" ];
      keepEnv = true;
    }];
  };

  environment.defaultPackages = with pkgs; [
    acpi
    alacritty
    ansible
    awscli2
    bind
    brightnessctl
    chromium
    clang-tools
    cobang
    coreutils
    curl
    dig
    discord
    distrobox
    drawio
    entr
    evince
    fd
    firefox-wayland
    flow
    fuzzel
    fwts
    fzf
    gcc
    git
    git-crypt
    go
    gopls
    gotools
    grim
    htop
    jq
    k9s
    kak-lsp
    kakoune
    kanshi
    killall
    kind
    krita
    kubectl
    libimobiledevice
    libnotify
    libreoffice
    libuuid
    lm_sensors
    lvm2
    mako
    moreutils
    mutt
    nix-tree
    nixpkgs-fmt
    numix-cursor-theme
    obs-studio
    pamixer
    pavucontrol
    pass
    peek
    pgcli
    playerctl
    powertop
    psmisc
    pstree
    ripgrep
    river
    rsync
    shellcheck
    shfmt
    signal-desktop
    slack
    slurp
    socat
    spotify
    swaybg
    swayidle
    swaylock
    terraform
    tmux
    tree
    unzip
    usbutils
    util-linux
    valgrind
    vim
    virt-manager
    vlc
    waybar
    webcamoid
    wget
    wl-clipboard
    xdg-desktop-portal
    xterm
    yubikey-manager
    yubioath-flutter
    zip
  ];

  programs.sway.enable = true;

  # Set up firefox for wayland usage
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = { ExtensionSettings = { }; };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    dejavu_fonts
    font-awesome
  ];
}
