{ inputs, ... }:
{
  flake-file.inputs = {
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.dms.homeManager =
    { lib, pkgs, ... }:
    {
      imports = [ inputs.dms.homeModules.dank-material-shell ];

      programs.dank-material-shell = {
        enable = true;

        quickshell.package = pkgs.quickshell;

        systemd = {
          enable = true;
          restartIfChanged = true;
        };

        enableSystemMonitoring = true;
        enableAudioWavelength = true;
        enableCalendarEvents = true;
        enableClipboardPaste = true;

        session = {
          nightModeEnabled = true;
          nightModeAutoEnabled = true;
          nightModeAutoMode = "location";
          nightModeTemperature = 3400;
          nightModeUseIPLocation = true;
        };

        settings = {
          loginctlLockIntegration = false;
          use24HourClock = false;
          clockDateFormat = "ddd MMM d";
          useAutoLocation = true;
          currentThemeCategory = "registry";
          customThemeFile = lib.mkForce "/home/cody/.config/DankMaterialShell/themes/catppuccin/theme.json";
          registryThemeVariants = {
            catppuccin = {
              dark = {
                flavor = "mocha";
                accent = "lavender";
              };
            };
          };
          showWorkspaceIndex = true;
          notificationPopupShadowEnabled = false;
          screenPreferences = {
            wallpaper = [ ];
          };
          controlCenterWidgets = [
            {
              id = "volumeSlider";
              enabled = true;
              width = 50;
            }
            {
              id = "bluetooth";
              enabled = true;
              width = 50;
            }
            {
              id = "wifi";
              enabled = true;
              width = 50;
            }
            {
              id = "builtin_vpn";
              enabled = true;
              width = 50;
            }
            {
              id = "audioOutput";
              enabled = true;
              width = 50;
            }
            {
              id = "audioInput";
              enabled = true;
              width = 50;
            }
            {
              id = "doNotDisturb";
              enabled = true;
              width = 50;
            }
            {
              id = "nightMode";
              enabled = true;
              width = 50;
            }
          ];
          barConfigs = [
            {
              id = "default";
              name = "Main Bar";
              enabled = true;
              position = 0;
              screenPreferences = [ "all" ];
              showOnLastDisplay = true;
              leftWidgets = [
                {
                  id = "workspaceSwitcher";
                  enabled = true;
                }
                {
                  id = "focusedWindow";
                  enabled = true;
                }
              ];
              centerWidgets = [
                "music"
                "weather"
              ];
              rightWidgets = [
                "systemTray"
                "clipboard"
                "notificationButton"
                "controlCenterButton"
                {
                  id = "clock";
                  enabled = true;
                  clockCompactMode = false;
                }
              ];
              spacing = 0;
              squareCorners = true;
            }
          ];
        };
      };
    };
}
