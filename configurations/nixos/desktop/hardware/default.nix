{
  imports = [
    ./graphics.nix
    ./fans.nix
  ];

  hardware = {
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    keyboard.qmk.enable = true;

    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
}
