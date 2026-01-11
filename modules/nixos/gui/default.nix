{ flake, ... }:
{
  imports = [
    flake.inputs.mango.nixosModules.mango

    ./stylix.nix
  ];

  programs.hyprland.enable = true;
  programs.mango.enable = true;
}
