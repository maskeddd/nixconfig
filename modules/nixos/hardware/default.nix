{
  imports = [
    ./nvidia.nix
    ./keyd.nix
  ];

  hardware = {
    graphics.enable = true;

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
