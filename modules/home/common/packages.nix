{ pkgs, ... }:
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    code-cursor
    telegram-desktop
    qbittorrent

    ripgrep
    fd
    sd
    tree
    gnumake

    cachix
    nil
    nixd
    nix-info
    nixpkgs-fmt
    devenv
  ];

  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    btop = {
      enable = true;
      package = pkgs.btop-cuda;
    };
  };
}
