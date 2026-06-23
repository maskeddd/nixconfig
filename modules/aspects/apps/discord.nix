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
          useQuickCss = true;
          themeLinks = [
            "https://catppuccin.github.io/discord/dist/catppuccin-mocha-lavender.theme.css"
          ];
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
      stylix.targets.nixcord.enable = false;
    };
    hmLinux.xdg.mimeApps.defaultApplications."x-scheme-handler/discord" = "vesktop.desktop";
  };
}
