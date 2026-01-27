{ pkgs, lib, ... }:
{
  programs.ghostty = {
    enable = true;

    package = lib.mkIf pkgs.stdenv.isDarwin pkgs.ghostty-bin;

    settings = {
      # font-family = "JetBrainsMono Nerd Font";
      # font-size = 16;
      command = "${pkgs.fish}/bin/fish";
      macos-titlebar-style = "hidden";
    };
  };
}
