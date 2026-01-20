{ pkgs, lib, ... }:
{
  programs.ghostty = {
    enable = true;

    package = lib.mkIf pkgs.stdenv.isDarwin pkgs.ghostty-bin;

    settings = {
      command = "${pkgs.fish}/bin/fish";
    };
  };
}
