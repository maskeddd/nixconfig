{ flake, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  programs.spicetify = {
    enable = true;
  };
}
