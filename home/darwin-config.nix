{lib, ...}: {
  home = {
    shellAliases = {
      ll = "ls -alh";
      l = "ls -l";
      fzf = "fzf --reverse";
      k = "kubectl";
      d = "docker";
      gs = "git status";
      gc = "git checkout";
      tf = "terraform";
      p = "podman";
      hg = "history 0 | grep";
    };

    sessionPath = [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];

    sessionVariables = {
      EDITOR = "hx";
      CONTAINERS_MACHINE_PROVIDER = "applehv";
    };

    file = {
      ".tmux.conf".source = ./tmux-darwin.conf;
      ".vimrc".source = ./vimrc;
      ".cargo/config.toml".source = ./cargo-config.toml;
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "Ameer Ghani";
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
            allowedSignersFile = "/Users/inahga/.config/git/allowed_signers";
          };
        };
        push = {
          autoSetupRemote = true;
        };
        safe = {
          directory = "/private/etc/nix-darwin";
        };
      };
    };

    starship = import ./starship.nix {inherit lib;};

    zsh = {
      enable = true;
      completionInit = "autoload -U compinit && compinit -u";
      initExtra = ''
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

        export PATH="$HOME/go/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

        TEMP_DIR="/Users/$USER/Library/Caches/TemporaryItems"
        mkdir -p "$TEMP_DIR"
        SSH_AGENT_ENV="$TEMP_DIR/ssh-agent.env"
        if ! pgrep -u "$USER" ssh-agent >/dev/null; then
            ssh-agent -t 1h >"$SSH_AGENT_ENV"
        fi
        if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
            source "$SSH_AGENT_ENV" >/dev/null
        fi
      '';
    };
  };

  targets.darwin = {
    currentHostDefaults = {
      NSGlobalDomain = {
        AppleFontSmoothing = 0;
      };
      "com.apple.controlcenter" = {
        BatteryShowPercentage = true;
      };
    };
    defaults = {
      NSGlobalDomain = {
        AppleInterfaceStyle = "Light";
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleShowAllExtensions = true;
        KeyRepeat = 1;
        NSDocumentSaveNewDocumentsToCloud = false;
      };
      "com.apple.Accessibility" = {
        ReduceMotionEnabled = true;
      };
      "com.apple.dock" = {
        autohide = true;
        mru-spaces = false;
        static-only = true;
      };
      "com.apple.finder" = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
      };
      "com.apple.safari" = {
        ShowFullURLInSmartSearchField = true;
      };
      "com.apple.WindowManager" = {
        EnableStandardClickToShowDesktop = false;
      };
    };
    search = "DuckDuckGo";
  };

  xdg.configFile = {
    "alacritty/alacritty.toml".source = ./alacritty.toml;
    "git/allowed_signers".source = ./allowed_signers;
    "helix/config.toml".source = ./helix-config.toml;
    "helix/languages.toml".source = ./helix-languages.toml;
    "helix/themes/inahga.toml".source = ./helix-theme-light.toml;
    "kak/kakrc".source = ./kakrc;
    "kak/shellcheck.kak".source = ./shellcheck.kak;
    "kak-lsp/kak-lsp.toml".source = ./kak-lsp.toml;
  };
}
