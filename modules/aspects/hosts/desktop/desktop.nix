{ den, ... }:
{
  den.aspects.desktop = {
    includes = with den.aspects; [
      audio
      graphics
      peripherals
      rgb
      fans
    ];
    nixos.imports = [ ./_hardware-configuration.nix ];
  };
}
