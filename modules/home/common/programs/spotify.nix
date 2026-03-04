{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  programs.spicetify = {
    enable = pkgs.stdenv.hostPlatform.system != "aarch64-linux";
  };
}
