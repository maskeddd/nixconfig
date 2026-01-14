{ flake, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.solaar.nixosModules.default
  ];

  services.solaar = {
    enable = true;
    window = "hide";
    batteryIcons = "regular";
  };
}
