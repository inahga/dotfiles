{
  config,
  pkgs,
  lib,
  ...
}: let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (import ../pkgs)

    # pin docker to older nixpkgs: https://github.com/NixOS/nixpkgs/issues/244159
    (let
      pinnedPkgs = import (pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = "b6bbc53029a31f788ffed9ea2d459f0bb0f0fbfc";
        sha256 = "sha256-JVFoTY3rs1uDHbh0llRb1BcTNx26fGSLSiPmjojT+KY=";
      }) {};
    in
      final: prev: {
        docker = pinnedPkgs.docker;
      })
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
    };
    nixPath = with config; [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/etc/nixos/hosts/${networking.hostName}/default.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
  boot = {
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 512;
    };
  };

  swapDevices = [
    {
      device = "/swap";
      size = 8192;
    }
  ];

  system.autoUpgrade.enable = true;

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
    nftables.enable = true;
    useDHCP = lib.mkDefault true;
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  hardware.bluetooth = {
    enable = true;
    settings = {General = {Enable = "Source,Sink,Media,Socket";};};
  };

  time.timeZone = "America/Chicago";

  users.users.inahga = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "libvirtd" "docker"];
    initialPassword = "password";
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJBN1uV3RK41ghFQLYqNTVXUVALbn3KDr3E8HCxk7zC8AAAAEXNzaDp5dWJpa2V5LXNtYWxs"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHLtwflRB2PAPOAtqRpH5z7TJ/AG9iKo9pDUo/NdP0KyAAAAEXNzaDp5dWJpa2V5LXNtYWxs"
    ];
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.river}/bin/river";
          user = "inahga";
        };
      };
    };
    dbus.enable = true;
    flatpak.enable = true;
    blueman.enable = true;
    fwupd.enable = true;
    pcscd.enable = true;
    gvfs.enable = true; # Mount, trash, SMB, other things...
    tumbler.enable = true; # Image thumbnail service.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security = {
    rtkit.enable = true;
    doas = {
      enable = true;
      extraRules = [
        {
          groups = ["wheel"];
          keepEnv = true;
        }
      ];
    };
    pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "65536";
      }
    ];
  };

  environment.defaultPackages = with pkgs; [
    _1password
    _1password-gui
    acpi
    act
    alacritty
    alejandra
    apacheHttpd # for `ab`
    ansible
    awscli2
    bc
    bind
    brightnessctl
    chromium
    clang-tools
    coreutils
    curl
    delve
    dig
    difftastic
    direnv
    discord
    distrobox
    drawio
    entr
    evince
    fd
    figlet
    file
    firefox-wayland
    flow
    fuzzel
    fwts
    fzf
    gcc
    gdb
    gettext
    gh
    ghidra-bin
    git
    git-crypt
    glow
    gnumake
    gnupg
    go
    gopls
    gotools
    grim
    grpc-tools
    helix
    htop
    hwinfo
    jq
    jupyter
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
    lsof
    lvm2
    mako
    moreutils
    marksman
    mutt
    netcat
    nil
    nix-tree
    nodejs
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    numix-cursor-theme
    obs-studio
    openssl
    pamixer
    pandoc
    pass
    pavucontrol
    peek
    perl
    pgcli
    playerctl
    pinentry
    pkg-config
    postgresql
    powertop
    psmisc
    pstree
    python3
    rclone
    ripgrep
    river
    rsync
    rustup
    shellcheck
    shfmt
    signal-desktop
    slack
    slurp
    socat
    spotify
    strace
    swaybg
    swayidle
    swaylock
    terraform
    terraform-ls
    tmux
    tree
    unzip
    usbutils
    util-linux
    valgrind
    vim
    virt-manager
    vlc
    vscode
    waybar
    webcamoid
    wireshark
    wget
    (with google-cloud-sdk; (withExtraComponents [components.gke-gcloud-auth-plugin]))
    wl-clipboard
    wlopm
    wlr-randr
    xdg-desktop-portal
    xdg-utils
    xfce.thunar
    xterm
    yarn
    yq
    yubikey-manager
    yubioath-flutter
    zip

    unstable.mold
  ];

  programs = {
    dconf.enable = true;
    # Set up firefox for wayland usage
    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraNativeMessagingHosts = with pkgs; [tridactyl-native];
        extraPolicies = {
          ExtensionSettings = {};
        };
      };
    };
    ssh = {
      startAgent = true;
      enableAskPassword = true;
    };
    sway.enable = true;
  };

  # Make screen sharing work.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-wlr xdg-desktop-portal-gtk];
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
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
      hack-font
    ];
    fontconfig = {
      defaultFonts = {
        monospace = ["Hack" "Noto Color Emoji"];
      };
    };
  };
}
