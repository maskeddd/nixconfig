{
  den.aspects.dev = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          claude-code
          codex
          typst

          jetbrains.rider

          nixd
          nil
        ];

        programs.opencode.enable = true;
        catppuccin.opencode.enable = true;
        stylix.targets.opencode.colors.enable = false;
      };
  };
}
