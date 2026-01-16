{ pkgs, ... }:
{
  imports = [
    ./keyd.nix
    ./audio.nix
    ./openrgb.nix
    ./uni-sync.nix
  ];

  hardware = {
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };

    services.udev.packages = [ pkgs.vial ];
    keyboard.qmk.enable = true;
  };
}
