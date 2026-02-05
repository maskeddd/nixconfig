{ pkgs, ... }:
{
  imports = [
    ./openrgb.nix
    ./kanata.nix
    ./pipewire.nix
  ];

  services.udev.packages = [ pkgs.vial ];
}
