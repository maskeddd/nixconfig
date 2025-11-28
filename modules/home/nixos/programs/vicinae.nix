{ flake, ... }:
{
  imports = [ flake.inputs.vicinae.homeManagerModules.default ];

  services.vicinae = {
    enable = true;
    autoStart = true;
    useLayerShell = true;
  };
}
