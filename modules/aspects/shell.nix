{
  den.aspects.shell = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          ripgrep
          fd
          sd
          tree
        ];

        home.shellAliases = {
          zed = "zeditor";
        };

        programs = {
          fish.interactiveShellInit = ''
            set fish_greeting
          '';

          starship = {
            enable = true;
            settings = {
              username = {
                style_user = "blue bold";
                style_root = "red bold";
                format = "[$user]($style) ";
                disabled = false;
                show_always = true;
              };
              hostname = {
                ssh_only = false;
                ssh_symbol = "🌐 ";
                format = "on [$hostname](bold red) ";
                trim_at = ".local";
                disabled = false;
              };
            };
          };

          zoxide.enable = true;

          direnv = {
            enable = true;
            nix-direnv.enable = true;
            config.global.hide_env_diff = true;
          };

          bat.enable = true;
          fzf.enable = true;
          jq.enable = true;
          fastfetch.enable = true;
          btop.enable = true;
        };
      };

    hmLinux =
      { pkgs, ... }:
      {
        programs.btop.package = pkgs.btop-cuda;
      };
  };
}
