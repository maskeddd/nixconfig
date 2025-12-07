{ flake, ... }:
{
  imports = [
    flake.inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    enable = false;
    flavor = "mocha";
    accent = "lavender";
    zed.enable = true;
    helix.enable = true;
  };
}
