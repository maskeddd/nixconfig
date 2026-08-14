{
  den.aspects.peripherals.nixos = {
    programs.solaar = {
      enable = true;
      userService.enable = true;
    };

    hardware = {
      keyboard.qmk.enable = true;
      opentabletdriver.enable = true;
    };
  };
}
