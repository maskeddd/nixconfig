{ flake, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    enable = false;
    flavor = "mocha";
    accent = "lavender";
    zed = {
      enable = false;
      icons.enable = true;
    };
  };
}
