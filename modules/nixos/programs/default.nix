{ pkgs, ... }:
{
  imports = [
    ./steam.nix
    ./1password.nix
  ];

  programs = {
    fish.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    hyprland.enable = true;
  };
}
