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
    inputs.stylix.nixosModules.stylix
    ./core.nix
    ./packages.nix
    ./services
    ./common
    ./programs
  ];

  stylix.targets.chromium.enable = false;
}
