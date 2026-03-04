{ pkgs, ... }:
{
  home.packages = with pkgs; [
    telegram-desktop
    qbittorrent
    brave

    ripgrep
    fd
    sd
    tree
    gnumake
    blink-roblox
    devenv

    cachix
    nix-info
    nixpkgs-fmt
  ];
}
