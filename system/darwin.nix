{pkgs, ...}: let
  unstable = import <nixpkgs-unstable> {config = {allowUnfree = true;};};
in {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    _1password
    act
    alejandra
    ansible
    apacheHttpd # for `ab`
    awscli2
    bc
    bind
    clang-tools
    coreutils
    curl
    delve
    dig
    direnv
    entr
    fd
    figlet
    file
    fzf
    gcc
    gettext
    gh
    git
    git-crypt
    gnumake
    gnupg
    go
    gopls
    gotools
    gron
    grpc-tools
    htop
    jq
    k9s
    kind
    kubectl
    kubernetes-helm
    moreutils
    marksman
    mutt
    netcat
    nil
    nodejs
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    openssl
    openssh
    pandoc
    pass
    perl
    pgcli
    pkg-config
    postgresql
    python3
    rclone
    ripgrep
    rsync
    rustup
    shellcheck
    shfmt
    socat
    terraform
    terraform-ls
    tmux
    tree
    unzip
    vim
    wget
    (with google-cloud-sdk; (withExtraComponents [components.gke-gcloud-auth-plugin]))
    yarn
    yq
    yubikey-manager
    zip

    unstable.helix
    unstable.kakoune
    unstable.kak-lsp
    unstable.mold
  ];

  programs = {
    man.enable = true;
    zsh = {
      enable = true;
      # https://github.com/LnL7/nix-darwin/issues/554#issuecomment-1289736477
      enableCompletion = false;
    };
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override {fonts = ["Hack"];})
    ];
  };

  homebrew = {
    enable = true;
    # These apps fall into one of the following categories:
    #   - They're a desktop app, and spotlight doesn't index nix-managed applications, or more
    #     precisely it doesn't index symlinks.
    #   - They are missing an aarch64 build in nixpkgs.
    casks = [
      "1password"
      "alacritty"
      "android-studio"
      "chromium"
      "discord"
      "drawio"
      "firefox"
      "ghidra"
      "obs"
      "rectangle"
      "slack"
      "spotify"
      "steam"
      "yubico-authenticator"
      "visual-studio-code"
      "vlc"
      "wireshark"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
}
