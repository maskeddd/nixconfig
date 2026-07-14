{ ... }:
{
  den.aspects.rift.hmDarwin =
    { pkgs, lib, ... }:
    let
      workspaceCount = 9;
      workspaceKeys = builtins.genList (i: toString (i + 1)) workspaceCount;

      workspaceSwitchBindings = builtins.listToAttrs (
        lib.imap0 (i: key: lib.nameValuePair "Alt + ${key}" { switch_to_workspace = i; }) workspaceKeys
      );

      workspaceMoveBindings = builtins.listToAttrs (
        lib.imap0 (
          i: key:
          lib.nameValuePair "comb1 + ${key}" {
            exec = [
              "/bin/bash"
              "-c"
              "rift-cli execute workspace move-window ${toString i} && rift-cli execute workspace switch ${toString i}"
            ];
          }
        ) workspaceKeys
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
          app_rules = [
            {
              title_substring = "Preferences";
              floating = true;
            }
            {
              app_id = "com.brave.Browser";
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
              app_id = "com.hnc.Discord";
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
            "bash"
            "-c"
            "open -a \"${pkgs.ghostty-bin}/Applications/Ghostty.app\""
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
        // workspaceSwitchBindings
        // workspaceMoveBindings;
      };
    };
}
