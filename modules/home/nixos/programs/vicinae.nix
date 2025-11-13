{ flake, ... }:
{
  imports = [ flake.inputs.vicinae.homeManagerModules.default ];

  services.vicinae = {
    enable = true;
    autoStart = true;
    useLayerShell = false;
    settings = {
      faviconService = "twenty";
      font.size = 11;
      font.family = "SF Pro Text";
      popToRootOnClose = false;
      rootSearch.searchFiles = false;
      theme.name = "catppuccin-mocha";
      window = {
        csd = true;
        opacity = 1;
        rounding = 10;
      };
    };
  };
}
