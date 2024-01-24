{lib, ...}:
with lib; {
  enable = true;
  settings = {
    add_newline = true;
    directory.truncate_to_repo = false;
    kubernetes = {
      disabled = false;
      format = "with [$symbol$context( \($namespace\))]($style) ";
      symbol = "";
      contexts = [
        {
          context_pattern = "gke_.*_(?P<cluster>[\\w-]+)";
          context_alias = "gke-$cluster";
        }
      ];
    };
    gcloud = {
      disabled = true;
      format = "[\\($symbol$account(@$domain)(\($region\))\\)]($style) ";
    };
    character = {
      success_symbol = "#";
      error_symbol = "#";
    };
    time = {
      disabled = false;
      format = "[$time]($style) ";
    };
    status.disabled = false;
    line_break.disabled = true;
    format = concatStringsSep "" [
      "$time"
      "$directory"
      "$username"
      "$hostname"
      "$localip"
      "$shlvl"
      "$singularity"
      "$kubernetes"
      "$vcsh"
      "$fossil_branch"
      "$fossil_metrics"
      "$git_branch"
      "$git_commit"
      "$git_state"
      "$git_metrics"
      "$git_status"
      "$hg_branch"
      "$pijul_channel"
      "$docker_context"
      "$package"
      "$c"
      "$cmake"
      "$cobol"
      "$daml"
      "$dart"
      "$deno"
      "$dotnet"
      "$elixir"
      "$elm"
      "$erlang"
      "$fennel"
      "$golang"
      "$guix_shell"
      "$haskell"
      "$haxe"
      "$helm"
      "$java"
      "$julia"
      "$kotlin"
      "$gradle"
      "$lua"
      "$nim"
      "$nodejs"
      "$ocaml"
      "$opa"
      "$perl"
      "$php"
      "$pulumi"
      "$purescript"
      "$python"
      "$raku"
      "$rlang"
      "$red"
      "$ruby"
      "$rust"
      "$scala"
      "$solidity"
      "$swift"
      "$terraform"
      "$typst"
      "$vlang"
      "$vagrant"
      "$zig"
      "$buf"
      "$nix_shell"
      "$conda"
      "$meson"
      "$spack"
      "$memory_usage"
      "$aws"
      "$gcloud"
      "$openstack"
      "$azure"
      "$direnv"
      "$env_var"
      "$crystal"
      "$custom"
      "$cmd_duration"
      "$line_break"
      "$jobs"
      "$battery"
      "$status"
      "$os"
      "$container"
      "$shell"
      "\n"
      "$sudo"
      "$character"
    ];
  };
}
