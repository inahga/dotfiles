{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  home-manager =
    builtins.fetchTarball
    "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
  cfg = config.custom;
in {
  imports = [(import "${home-manager}/nixos")];

  options.custom.hidpi = mkOption {
    default = true;
    type = types.bool;
  };
  options.custom.email = mkOption {
    default = "inahga@gmail.com";
    type = types.str;
  };
  options.custom.light_mode = mkOption {
    default = false;
    type = types.bool;
  };

  config = {
    home-manager.users.inahga = {
      home.stateVersion = "23.05";

      home.shellAliases = {
        ll = "ls -alh";
        l = "ls -l";
        fzf = "fzf --reverse";
        k = "kubectl";
        d = "docker";
        gs = "git status";
        gc = "git checkout";
        tf = "terraform";
        p = "podman";
        ssh-add = "ssh-add -t 28800";
      };

      services.mpris-proxy.enable = true;

      services.gpg-agent = {
        enable = true;
        pinentryFlavor = "tty";
      };

      programs.git = {
        enable = true;
        userName = "Ameer Ghani";
        userEmail = cfg.email;
        ignores = ["aghani*" "inahga*"];
        extraConfig = {
          commit = {
            gpgsign = true;
          };
          gpg = {
            format = "ssh";
            ssh = {
              defaultKeyCommand = ''
                env bash -c "ssh-add -L | head -n1 | sed 's/^/key::/'"
              '';
              allowedSignersFile = "/home/inahga/.config/git/allowed_signers";
            };
          };
          push = {
            autoSetupRemote = true;
          };
        };
      };

      programs.bash = {
        enable = true;
        bashrcExtra = ''
          shopt -s histappend
          shopt -s cmdhist
          export HISTFILESIZE=16777216
          export HISTSIZE=16777216
          export HISTCONTROL=ignoreboth
          export HISTIGNORE='ls:bg:fg:history:l:ll:cd:gs'
          export PROMPT_COMMAND='history -a; history -c; history -r'
          export HISTTIMEFORMAT='%F %T '

          export PATH="$HOME/go/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
          if [ -e ~/.git-prompt ]; then
              source ~/.git-prompt
          fi

          export GLADMOJI="😀😅😆😄😃😇😉😊🙂😋😍😘😜😝😛😎😏😻😺🙌💪👌🌞🔥👍💕💯✅🆒🆗💲"
          export SADMOJI="😶😳😠😞😡😕😣😖😫😩😮😱😨😰😯😦😢😥😥😵😭😴😷💀😿👎🙊💥🔪💔🆘⛔🚫❌🚷❓❗"
          export PROMPT_DIRTRIM=3
          export PS1="\n\[\033[1;31m\]\$(if [ -n \"\$IN_NIX_SHELL\" ]; then echo \"[\$name] \"; fi)\[\033[0m\]\
          \e[34m\u@\h\[\e[0m\] \
          \$(if [ \$? == 0 ]; then echo -n \"\''${GLADMOJI:RANDOM%\''${#GLADMOJI}:1}\"; \
          else echo -n \"\''${SADMOJI:RANDOM%\''${#SADMOJI}:1}\"; fi)\
          \$(if [ -e ~/.git-prompt ]; then __git_ps1 \" (git: %s)\"; fi) \w\n🐧 "

          DEFAULT_TMUX="base"
          if [ -z "$TMUX" ]; then
              if tmux ls |& grep $DEFAULT_TMUX >/dev/null 2>&1; then
                  tmux attach -t $DEFAULT_TMUX
              else
                  tmux new-session -t $DEFAULT_TMUX
              fi
          fi

          gocover() {
              FILE=''${1:-coverage.out}
              go test -coverprofile "$FILE"
              go tool cover -html="$FILE"
          }

          if [ "$(uname -s)" == "Linux" ]; then
              alias open='xdg-open'
          fi

          alias kakoune='command kak'
          kak() {
              GITREPO=$(git rev-parse --show-toplevel 2>/dev/null)
              SESSION=general
              if [ -n "$GITREPO" ]; then
                  SESSION=$(echo "$GITREPO" | md5sum | head -c6)
              fi

              if command kak -l | grep -q "$SESSION"; then
                  command kak -c "$SESSION" "$@"
              else
                  command kak -s "$SESSION" "$@"
              fi
          }

          alacritty-x11() {
              WINIT_UNIX_BACKEND=x11 alacritty "$@"
          }

          # alacritty pinebook pro fix
          # https://github.com/alacritty/alacritty/issues/128#issuecomment-663927477
          if [ "$(uname -m)" == "aarch64" ]; then
              export PAN_MESA_DEBUG=gl3
          fi

          if [ -e "$HOME/.bashrc-custom" ]; then
              source "$HOME/.bashrc-custom"
          fi
        '';
        initExtra = ''
          export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
        '';
      };

      programs.firefox = {enable = true;};
      programs.direnv.enable = true;

      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        XDG_CURRENT_DESKTOP = "river";
        XKB_DEFAULT_OPTIONS = "caps:escape";
        EDITOR = "kak";
        NIX_SHELL_PRESERVE_PROMPT = 1;
        HIDPI =
          if cfg.hidpi
          then 1
          else 0;
        QT_SCALE_FACTOR =
          if cfg.hidpi
          then "2.0"
          else "1.0";
        _JAVA_AWT_WM_NONREPARENTING = 1;
      };

      xdg.configFile = {
        "river/init" = {
          source = ./river-init.sh;
          executable = true;
        };

        "kak/kakrc".source = ./kakrc;
        "kak/shellcheck.kak".source = ./shellcheck.kak;

        "mako/config".source = with pkgs;
          substituteAll {
            src = ./mako-config;
            inherit bash;
            fontSize =
              if cfg.hidpi
              then 24
              else 12;
            width =
              if cfg.hidpi
              then 600
              else 300;
            height =
              if cfg.hidpi
              then 300
              else 100;
          };

        "helix/config.toml".source = ./helix-config.toml;
        "helix/languages.toml".source = ./helix-languages.toml;
        "helix/themes/inahga.toml".source =
          if cfg.light_mode
          then ./helix-theme-light.toml
          else ./helix-theme.toml;

        "git/allowed_signers".source = ./allowed_signers;
        "kak-lsp/kak-lsp.toml".source = ./kak-lsp.toml;
        "alacritty/alacritty.yml".source = with pkgs;
          substituteAll {
            src =
              if cfg.light_mode
              then ./alacritty-light.yml
              else ./alacritty.yml;
            inherit bash;
            fontSize =
              if cfg.hidpi
              then 25.5
              else 16;
          };
        "kanshi/config".source = ./kanshi-config;

        "waybar/config".source = ./waybar-config;
        "waybar/style.css".source = with pkgs;
          substituteAll {
            src = ./waybar-style.css;
            inherit bash;
            fontSize =
              if cfg.hidpi
              then 28
              else 16;
          };

        "swaylock/config".source = ./swaylock-config;
      };

      home.file = {
        ".tmux.conf".source =
          if cfg.light_mode
          then ./tmux-light.conf
          else ./tmux.conf;
        ".vimrc".source = ./vimrc;
        ".git-prompt".source = ./git-prompt.sh;
        ".cargo/config.toml".source = ./cargo-config.toml;
      };

      gtk = {
        enable = true;
        theme = {
          name =
            if cfg.light_mode
            then "Materia-light"
            else "Materia-dark";
          package = pkgs.materia-theme;
        };
        iconTheme = {
          name = "BeautyLine";
          package = pkgs.beauty-line-icon-theme;
        };
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme =
            if cfg.light_mode
            then "prefer-light"
            else "prefer-dark";
          cursor-size =
            if cfg.hidpi
            then 48
            else 24;
          text-scaling-factor =
            if cfg.hidpi
            then 1.5
            else 1.0;
        };
      };

      home.pointerCursor = {
        package = pkgs.numix-cursor-theme;
        name = "Numix-Cursor-Light";
        size =
          if cfg.hidpi
          then 48
          else 24;
        x11.enable = true;
        gtk.enable = true;
      };
    };
  };
}
