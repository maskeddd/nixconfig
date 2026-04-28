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
    typst
    claude-code

    cachix
    nix-info
    nixpkgs-fmt
  ];
}
