{ flake, ... }:
{
  imports = [
    flake.inputs.nixcord.homeModules.nixcord
  ];

  programs.nixcord = {
    enable = true;
    config = {
      useQuickCss = true;
      themeLinks = [
        "https://raw.githubusercontent.com/refact0r/midnight-discord/refs/heads/master/themes/flavors/midnight-catppuccin-mocha.theme.css"
      ];
      plugins = {
        anonymiseFileNames.enable = true;
        betterGifPicker.enable = true;
        clearURLs.enable = true;
        memberCount.enable = true;
        messageLogger.enable = true;
        spotifyControls.enable = true;
        silentTyping.enable = true;
        gameActivityToggle.enable = true;
      };
    };
  };
}
