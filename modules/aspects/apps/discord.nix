{ inputs, ... }:
{
  flake-file.inputs.nixcord.url = "github:FlameFlag/nixcord";
  den.aspects.discord = {
    homeManager = {
      imports = [ inputs.nixcord.homeModules.nixcord ];
      programs.nixcord = {
        enable = true;
        vesktop.enable = true;
        discord = {
          vencord.enable = true;
          krisp.enable = true;
        };
        config = {
          useQuickCss = true;
          plugins = {
            anonymiseFileNames.enable = true;
            betterGifPicker.enable = true;
            clearUrls.enable = true;
            memberCount.enable = true;
            messageLogger.enable = true;
            spotifyControls.enable = true;
            silentTyping.enable = true;
            gameActivityToggle.enable = true;
            voiceChatDoubleClick.enable = true;
          };
        };
      };
    };
    hmLinux =
      { config, ... }:
      {
        xdg.mimeApps.defaultApplicationPackages = [ config.programs.nixcord.vesktop.package ];
      };
  };
}
