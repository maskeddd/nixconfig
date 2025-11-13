{ flake, pkgs, ... }:
let
  spicePkgs = flake.inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [
    flake.inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };
}
