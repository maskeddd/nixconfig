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
          ghostty = {
            enable = true;
            settings = {
              command = "${pkgs.fish}/bin/fish";
              macos-titlebar-style = "hidden";
            };
          };

          fish = {
            enable = true;
            interactiveShellInit = ''
              set fish_greeting
            '';
          };

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
            nix-direnv = {
              enable = true;
            };
            config.global = {
              hide_env_diff = true;
            };
          };

          bat.enable = true;
          fzf.enable = true;
          jq.enable = true;
          fastfetch.enable = true;
          btop = {
            enable = true;
            package = pkgs.btop-cuda;
          };
        };
      };

    hmDarwin =
      { pkgs, ... }:
      {
        programs.ghostty.package = pkgs.ghostty-bin;
      };
  };
}
