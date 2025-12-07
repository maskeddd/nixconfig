{
  imports = [
    ./keyd.nix
    ./audio.nix
    ./openrgb.nix
  ];

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
}
