{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    {
      home-manager.sharedModules = [
        self.homeModules.nixos
      ];
    }
    ./core.nix
    ./polkit.nix
    ./hardware
    ./gui
    ./common
    ./services
    ./programs
  ];
}
