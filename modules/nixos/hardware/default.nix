{ pkgs, ... }:
{
  imports = [
    ./keyd.nix
    ./audio.nix
    ./openrgb.nix
    ./uni-sync.nix
  ];

  services.udev.packages = [ pkgs.vial ];

  hardware = {
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };

    keyboard.qmk.enable = true;
  };
}
