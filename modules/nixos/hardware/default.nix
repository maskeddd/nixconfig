{
  imports = [
    ./keyd.nix
  ];

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
}
