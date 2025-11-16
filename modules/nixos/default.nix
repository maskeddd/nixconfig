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
    ./packages.nix
    ./hardware
    ./gui
    ./common
    ./services
    ./programs
  ];
}
