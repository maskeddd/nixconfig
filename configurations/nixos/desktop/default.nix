{ flake, config, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    ./hardware-configuration.nix
    ./hardware
    ./services
  ];

  networking.hostName = "desktop";

  # Host state version; keep per-machine
  system.stateVersion = "25.05";
}
