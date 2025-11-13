{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      command = "${pkgs.fish}/bin/fish";
    };
  };
}
