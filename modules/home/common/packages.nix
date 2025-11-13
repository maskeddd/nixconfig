{ pkgs, ... }:
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    brave
    code-cursor
    telegram-desktop

    ripgrep
    fd
    sd
    tree
    gnumake

    cachix
    nil
    nix-info
    nixpkgs-fmt
  ];

  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    btop.enable = true;
  };
}
