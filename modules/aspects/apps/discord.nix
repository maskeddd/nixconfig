{ inputs, ... }:
{
  flake-file.inputs.nixcord.url = "github:FlameFlag/nixcord";
  den.aspects.discord = {
    homeManager = {
      imports = [ inputs.nixcord.homeModules.nixcord ];
      programs.nixcord = {
        enable = true;
        vesktop.enable = true;
        discord.enable = false;
        config = {
          plugins = {
            anonymiseFileNames.enable = true;
            betterGifPicker.enable = true;
            ClearURLs.enable = true;
            memberCount.enable = true;
            messageLogger.enable = true;
            spotifyControls.enable = true;
            silentTyping.enable = true;
            gameActivityToggle.enable = true;
          };
        };
      };
    };
    hmLinux = {
      xdg.mimeApps.defaultApplications."x-scheme-handler/discord" = "vesktop.desktop";
    };
  };
}
