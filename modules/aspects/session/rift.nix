{ inputs, ... }:
{
  flake-file.inputs.acsandmann-rift = {
    url = "github:acsandmann/homebrew-tap";
    flake = false;
  };

  den.aspects.rift.darwin = {
    nix-homebrew = {
      taps."acsandmann/homebrew-tap" = inputs.acsandmann-rift;
      trust.formulae = [ "acsandmann/tap/rift" ];
    };
    homebrew.brews = [ "rift" ];
  };

  den.aspects.rift.hmDarwin =
    { pkgs, lib, ... }:
    let
      workspaceCount = 9;

      workspaceBindings = lib.mergeAttrsList (
        builtins.genList (
          i:
          let
            key = toString (i + 1);
          in
          {
            "Alt + ${key}".switch_to_workspace = i;
            "comb1 + ${key}".move_window_to_workspace = {
              workspace = i;
              follow = true;
            };
          }
        ) workspaceCount
      );
    in
    {
      home.file.".config/rift/config.toml".source = (pkgs.formats.toml { }).generate "rift-config.toml" {
        settings = {
          default_disable = false;
          animate = true;

          layout = {
            mode = "bsp";

            gaps = {
              outer = {
                top = 9;
                left = 9;
                bottom = 9;
                right = 9;
              };

              inner = {
                horizontal = 9;
                vertical = 9;
              };
            };
          };

          ui = {
            menu_bar = {
              enabled = true;
              display_style = "label";
            };

            stack_line = {
              thickness = 0.0;
              spacing = 0.0;
            };

            mission_control.enabled = true;
          };

          gestures = {
            enabled = true;
            skip_empty = true;
            fingers = 4;
          };
        };

        virtual_workspaces = {
          default_workspace_count = workspaceCount;
          app_rules =
            map (rule: rule // { floating = true; }) [
              { app_id = "com.apple.systempreferences"; }
              { app_id = "com.apple.calculator"; }
              { app_id = "com.apple.archiveutility"; }
              { app_id = "com.apple.installer"; }
              { app_id = "com.apple.DigitalColorMeter"; }
              { app_id = "com.apple.SystemProfiler"; }
              { app_id = "com.apple.PhotoBooth"; }
              { app_id = "com.apple.QuickTimePlayerX"; }
              { title_substring = "Preferences"; }
            ]
            ++ [
              {
                app_id = "net.imput.helium";
                workspace = 0;
              }
              {
                app_id = "dev.zed.Zed";
                workspace = 1;
              }
              {
                app_id = "dev.vencord.Vesktop";
                workspace = 2;
              }
              {
                app_id = "com.spotify.Client";
                workspace = 3;
              }
            ];
        };

        modifier_combinations.comb1 = "Alt + Shift";

        keys = {
          "Alt + Z" = "toggle_space_activated";

          "Alt + Left".move_focus = "left";
          "Alt + Down".move_focus = "down";
          "Alt + Up".move_focus = "up";
          "Alt + Right".move_focus = "right";

          "Alt + Enter".exec = [
            "osascript"
            "-e"
            ''
              tell application "Ghostty"
                if it is running then
                  new window
                else
                  activate
                end if
              end tell
            ''
          ];
          "Alt + E".exec = [
            "open"
            "-a"
            "Finder"
          ];

          "Alt + Tab" = "switch_to_last_workspace";
          "Alt + Q" = "close_window";

          "Alt + Shift + Left".join_window = "left";
          "Alt + Shift + Right".join_window = "right";
          "Alt + Shift + Up".join_window = "up";
          "Alt + Shift + Down".join_window = "down";

          "Alt + Comma" = "toggle_stack";
          "Alt + Slash" = "toggle_orientation";
          "Alt + Ctrl + E" = "unjoin_windows";

          "Alt + F" = "toggle_fullscreen";
          "Alt + Shift + F" = "toggle_window_floating";
          "comb1 + Ctrl + Space" = "toggle_focus_floating";

          "Alt + Shift + Equal" = "resize_window_grow";
          "Alt + Shift + Minus" = "resize_window_shrink";
        }
        // workspaceBindings;
      };
    };
}
