{
  imports = [
    ./uni-sync.nix
  ];

  hardware = {
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };

    keyboard.qmk.enable = true;
  };
}
