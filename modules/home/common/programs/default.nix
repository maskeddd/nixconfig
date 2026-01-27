{ pkgs, ... }:
{
  imports = [
    ./discord.nix
    ./helix.nix
    ./zed.nix
    ./spotify.nix
    ./ghostty.nix
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
