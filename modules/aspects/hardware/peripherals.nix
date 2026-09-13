{
  den.aspects.peripherals.nixos = {
    services.keyd = {
      enable = true;
      keyboards.pro-x = {
        ids = [ "m:046d:4093" ];
        settings = {
          main.mouse2 = "toggle(right-click-q)";
          right-click-q.rightmouse = "q";
        };
      };
    };

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
