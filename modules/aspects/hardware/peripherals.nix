{ inputs, ... }:
{
  flake-file.inputs.solaar = {
    url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.peripherals.nixos = {
    imports = [ inputs.solaar.nixosModules.default ];

    services = {
      solaar = {
        enable = true;
        window = "hide";
        batteryIcons = "regular";
      };
    };

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
  };
}
