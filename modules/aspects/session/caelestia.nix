{ inputs, ... }: {
  flake-file.inputs.caelestia-shell = {
    url = "github:dim-ghub/caelestia-shell";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.caelestia = {
    homeManager = { pkgs, ... }: {
      imports = [ inputs.caelestia-shell.homeManagerModules.default ];

      xdg.configFile."caelestia/monitors/DP-2/shell.json" = {
        force = true;
        text = builtins.toJSON {
          lock.enabled = false;
        };
      };

      programs.caelestia = {
        enable = true;
        package =
          inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.with-cli.overrideAttrs
            (old: {
              buildInputs = old.buildInputs ++ [ pkgs.qt6.qtmultimedia ];
            });

        settings = {
          ai.enableOllama = false;
          background.wallpaperEnabled = false;
          bar = {
            clock = {
              background = true;
              showDate = true;
            };
            entries = [
              {
                enabled = true;
                id = "logo";
              }
              {
                enabled = true;
                id = "workspaces";
              }
              {
                enabled = true;
                id = "spacer";
              }
              {
                enabled = true;
                id = "activeWindow";
              }
              {
                enabled = false;
                id = "dock";
              }
              {
                enabled = true;
                id = "spacer";
              }
              {
                enabled = true;
                id = "tray";
              }
              {
                enabled = true;
                id = "github";
              }
              {
                enabled = true;
                id = "clock";
              }
              {
                enabled = true;
                id = "statusIcons";
              }
              {
                enabled = true;
                id = "power";
              }
            ];
            position = "top";
            scrollActions = {
              brightness = false;
              volume = false;
            };
            status = {
              showBattery = false;
              showPeripheralBattery = true;
            };
          };
          dashboard.showTerminal = false;
          general = {
            apps = {
              explorer = [
                "nautilus"
                "--new-window"
              ];
              terminal = [
                "${pkgs.ghostty}/bin/ghostty"
                "--gtk-single-instance=true"
              ];
            };
          };
          launcher = {
            enableDangerousActions = true;
            useFuzzy.apps = true;
          };
          shimeji.enabled = false;
        };

        cli = {
          enable = true;

          settings.theme = {
            enableTerm = false;
            enableHypr = false;
            enableDiscord = false;
            enableSpicetify = false;
            enablePandora = false;
            enableFuzzel = false;
            enableBtop = false;
            enableNvtop = false;
            enableHtop = false;
            enableGtk = false;
            enableQt = false;
            enableWarp = false;
            enableChromium = false;
            enableZed = false;
            enableCava = false;
          };
        };
      };
    };
  };
}
