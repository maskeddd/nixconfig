{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  programs.spicetify = {
    enable = false;
    theme = spicePkgs.themes.text;
    colorScheme = "Nord";
  };
}
