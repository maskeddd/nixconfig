{ pkgs, ... }:
{
  imports = [
    ./editors
    ./discord.nix
    ./ghostty.nix
    ./git.nix
    ./spotify.nix
    ./obsidian.nix
  ];

  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    btop = {
      enable = true;
      package = pkgs.btop-cuda;
    };
    fastfetch = {
      enable = true;
    };
  };
}
