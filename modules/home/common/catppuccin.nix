{ flake, ... }:
{
  imports = [
    flake.inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    enable = false;
    flavor = "mocha";
    accent = "lavender";
    zed = {
      enable = true;
      icons.enable = true;
    };
    helix.enable = true;
    vscode.profiles.default = {
      enable = true;
      icons.enable = true;
    };
  };
}
