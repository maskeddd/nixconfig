{ flake, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.mango.nixosModules.mango

    ./stylix.nix
  ];

  programs.hyprland.enable = true;
  programs.mango.enable = true;
}
