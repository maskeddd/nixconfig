{ pkgs, lib, ... }:
let
  workspaceSwitchBindings = lib.concatStringsSep "\n" (
    lib.genList (i: ''"Alt + ${toString (i + 1)}" = { switch_to_workspace = ${toString i} }'') 9
  );

  workspaceMoveBindings = lib.concatStringsSep "\n" (
    lib.genList (i: ''"comb1 + ${toString (i + 1)}" = { move_window_to_workspace = ${toString i} }'') 9
  );
in
{
  home.file.".config/rift/config.toml".text = ''
    [settings]
    default_disable = false
    animate = false
    animation_duration = 0.3
    animation_fps = 100.0
    animation_easing = "ease_in_out"
    focus_follows_mouse = true
    mouse_follows_focus = true
    mouse_hides_on_focus = true
    auto_focus_blacklist = []
    run_on_start = []
    hot_reload = true

    [settings.layout]
    mode = "bsp"

    [settings.layout.stack]
    stack_offset = 40.0
    default_orientation = "perpendicular"

    [settings.layout.gaps]

    [settings.layout.gaps.outer]
    top = 12
    left = 12
    bottom = 12
    right = 12

    [settings.layout.gaps.inner]
    horizontal = 6
    vertical = 6

    [settings.ui.menu_bar]
    enabled = true
    show_empty = false
    display_style = "label"

    [settings.ui.stack_line]
    enabled = false
    horiz_placement = "top"
    vert_placement = "left"
    thickness = 0.0
    spacing = 0.0

    [settings.ui.mission_control]
    enabled = false
    fade_enabled = false
    fade_duration_ms = 180.0

    [settings.gestures]
    enabled = true
    invert_horizontal_swipe = false
    swipe_vertical_tolerance = 0.4
    skip_empty = true
    fingers = 3
    distance_pct = 0.08
    haptics_enabled = true
    haptic_pattern = "level_change"

    [settings.window_snapping]
    drag_swap_fraction = 0.3

    [virtual_workspaces]
    enabled = true
    default_workspace_count = 10
    auto_assign_windows = true
    preserve_focus_per_workspace = true
    workspace_auto_back_and_forth = false
    workspace_names = [
      "first",
      "second"
    ]
    app_rules = []

    [modifier_combinations]
    comb1 = "Alt + Shift"

    [keys]
    # Toggle space
    "Alt + Z" = "toggle_space_activated"

    # Focus movement
    "Alt + H" = { move_focus = "left" }
    "Alt + J" = { move_focus = "down" }
    "Alt + K" = { move_focus = "up" }
    "Alt + L" = { move_focus = "right" }

    # Window movement
    "comb1 + H" = { move_node = "left" }
    "comb1 + J" = { move_node = "down" }
    "comb1 + K" = { move_node = "up" }
    "comb1 + L" = { move_node = "right" }

    # Workspace switching
    ${workspaceSwitchBindings}

    # Move window to workspace
    ${workspaceMoveBindings}

    # Terminal
    "Alt + Enter" = { "exec" = ["bash", "-c", "open -a \"${pkgs.ghostty-bin}/Applications/Ghostty.app\""] }

    # Workspace navigation
    "Alt + Tab" = "switch_to_last_workspace"

    # Window joining
    "Alt + Shift + Left" = { join_window = "left" }
    "Alt + Shift + Right" = { join_window = "right" }
    "Alt + Shift + Up" = { join_window = "up" }
    "Alt + Shift + Down" = { join_window = "down" }

    # Layout controls
    "Alt + Comma" = "toggle_stack"
    "Alt + Slash" = "toggle_orientation"
    "Alt + Ctrl + E" = "unjoin_windows"

    # Window states
    "Alt + Shift + Space" = "toggle_window_floating"
    "Alt + F" = "toggle_fullscreen"
    "Alt + Shift + F" = "toggle_fullscreen_within_gaps"
    "comb1 + Ctrl + Space" = "toggle_focus_floating"

    # Window resizing
    "Alt + Shift + Equal" = "resize_window_grow"
    "Alt + Shift + Minus" = "resize_window_shrink"
  '';
}
