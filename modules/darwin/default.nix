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
    inputs.stylix.darwinModules.stylix

    ./common
    ./homebrew.nix
    #./kanata.nix
    ./borders.nix
  ];

  programs.fish.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    defaults = {
      dock = {
        autohide = true;
        persistent-apps = [
          { app = "${pkgs.brave}/Applications/Brave Browser.app"; }
          { app = "/Users/cody/Applications/Home Manager Apps/Discord.app"; }
          {
            app = "/Users/cody/Applications/Home Manager Apps/Spotify.app";
          }
          { app = "${pkgs.ghostty-bin}/Applications/Ghostty.app"; }
          {
            app = "${pkgs.zed-editor}/Applications/Zed.app";
          }
          {
            app = "/System/Applications/System Settings.app";
          }
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
