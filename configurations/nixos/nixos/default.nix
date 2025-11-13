# See /modules/nixos/* for actual settings
# This file is host-level configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    self.nixosModules.gui
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos";

  # Host state version; keep per-machine
  system.stateVersion = "25.05";
}
