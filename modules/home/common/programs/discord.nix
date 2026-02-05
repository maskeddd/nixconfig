{ flake, pkgs, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  programs.nixcord = {
    enable = !pkgs.stdenv.isAarch64;
    config = {
      useQuickCss = true;
      themeLinks = [
        "https://raw.githubusercontent.com/refact0r/midnight-discord/refs/heads/master/themes/flavors/midnight-nord.theme.css"
      ];
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
}
