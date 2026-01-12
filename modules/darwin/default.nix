{
  flake,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    {
      home-manager.sharedModules = [
        self.homeModules.darwin
      ];
    }
    ./common
    ./homebrew.nix
  ];

  programs.fish.enable = true;

  # Use TouchID for `sudo` authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Configure macOS system
  # More macbooks => https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/rich-demo/modules/system.nix
  system = {
    defaults = {
      dock = {
        autohide = true;
        persistent-apps = [
          { app = "${pkgs.brave}/Applications/Brave Browser.app"; }
          {
            app = "${pkgs.spotify}/Applications/Spotify.app";
          }
          { app = "${pkgs.ghostty-bin}/Applications/Ghostty.app"; }
        ];
        tilesize = 64;
      };

      finder = {
        _FXShowPosixPathInTitle = true; # show full path in finder title
        AppleShowAllExtensions = true; # show all file extensions
        FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
        QuitMenuItem = true; # enable quit menu item
        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
      };
    };

    keyboard = {
      # enableKeyMapping = true;
      # remapCapsLockToControl = true;
    };
  };
}
