{ pkgs, ... }:
{
  home.packages = with pkgs; [
    telegram-desktop
    qbittorrent
    jetbrains.rider
    brave

    ripgrep
    fd
    sd
    tree
    gnumake
    blink-roblox

    cachix
    nix-info
    nixpkgs-fmt
    devenv
  ];
}
