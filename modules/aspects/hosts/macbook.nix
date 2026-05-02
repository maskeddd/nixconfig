{ den, ... }:
{
  den.aspects.macbook = {
    includes = with den.aspects; [
      homebrew
      borders
    ];

    darwin =
      { pkgs, ... }:
      {
        system.stateVersion = 6;

        security.pam.services.sudo_local.touchIdAuth = true;

        system.defaults = {
          dock = {
            autohide = true;
            tilesize = 64;
            persistent-apps = [
              { app = "${pkgs.brave}/Applications/Brave Browser.app"; }
              { app = "/Users/cody/Applications/Home Manager Apps/Discord.app"; }
              { app = "/Users/cody/Applications/Home Manager Apps/Spotify.app"; }
              { app = "${pkgs.ghostty-bin}/Applications/Ghostty.app"; }
              { app = "${pkgs.zed-editor}/Applications/Zed.app"; }
              { app = "/System/Applications/System Settings.app"; }
            ];
          };

          finder = {
            _FXShowPosixPathInTitle = true;
            AppleShowAllExtensions = true;
            FXEnableExtensionChangeWarning = false;
            QuitMenuItem = true;
            ShowPathbar = true;
            ShowStatusBar = true;
          };
        };
      };
  };
}
