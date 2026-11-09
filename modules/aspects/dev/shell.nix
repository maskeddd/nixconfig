{ den, ... }:
{
  den.aspects.shell = {
    includes = [ den.aspects.starship ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          ripgrep
          fd
          sd
          tree
        ];

        programs = {
          fish.interactiveShellInit = ''
            set fish_greeting
          '';

          zoxide.enable = true;

          direnv = {
            enable = true;
            nix-direnv.enable = true;
          };

          bat.enable = true;
          fzf.enable = true;
          vivid.enable = true;
          jq.enable = true;
          fastfetch.enable = true;
          btop.enable = true;
        };
      };
  };
}
