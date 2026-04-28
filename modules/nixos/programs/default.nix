{ flake, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.aagl.nixosModules.default

    ./steam.nix
    ./1password.nix
    ./niri.nix
  ];

  programs = {
    fish.enable = true;
    hyprland.enable = true;
    anime-game-launcher.enable = true;
  };
}
