{
  den.aspects.vicinae = {
    homeManager = {
      programs.vicinae = {
        enable = true;
        useLayerShell = true;
        systemd = {
          enable = true;
          autoStart = true;
        };
      };
    };
  };
}
