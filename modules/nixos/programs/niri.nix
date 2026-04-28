{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
}
