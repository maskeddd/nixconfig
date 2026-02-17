{
  flake,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  programs = {
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
  };

  nix = {
    package = lib.mkDefault pkgs.nix;

    gc = {
      automatic = true;
      dates = "weekly";
    };

    settings.auto-optimise-store = true;
  };

  home.packages = [
    config.nix.package
  ];
}
