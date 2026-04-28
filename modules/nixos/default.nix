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
    ./myusers.nix
    ./nix.nix
    ./stylix.nix
    ./packages.nix
    ./services
    ./programs
  ];

  stylix.targets.chromium.enable = false;
}
