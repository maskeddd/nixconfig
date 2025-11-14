{
  home.file.".config/rift/config.toml".text = ''
    [settings]
    animate = true
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
    top = 24
    left = 24
    bottom = 24
    right = 24

    [settings.layout.gaps.inner]
    horizontal = 12
    vertical = 12

    [settings.ui.menu_bar]
    enabled = true
    show_empty = false

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
    "Alt + Z" = "toggle_space_activated"
    "Alt + H" = { move_focus = "left" }
    "Alt + J" = { move_focus = "down" }
    "Alt + K" = { move_focus = "up" }
    "Alt + L" = { move_focus = "right" }
    "comb1 + H" = { move_node = "left" }
    "comb1 + J" = { move_node = "down" }
    "comb1 + K" = { move_node = "up" }
    "comb1 + L" = { move_node = "right" }

    "Alt + 1" = { switch_to_workspace = 0 }
    "Alt + 2" = { switch_to_workspace = 1 }
    "Alt + 3" = { switch_to_workspace = 2 }
    "Alt + 4" = { switch_to_workspace = 3 }
    "Alt + 5" = { switch_to_workspace = 4 }
    "Alt + 6" = { switch_to_workspace = 5 }
    "Alt + 7" = { switch_to_workspace = 6 }
    "Alt + 8" = { switch_to_workspace = 7 }
    "Alt + 9" = { switch_to_workspace = 8 }
    "Alt + 0" = { switch_to_workspace = 9 }

    "comb1 + 1" = { move_window_to_workspace = 0 }
    "comb1 + 2" = { move_window_to_workspace = 1 }
    "comb1 + 3" = { move_window_to_workspace = 2 }
    "comb1 + 4" = { move_window_to_workspace = 3 }
    "comb1 + 5" = { move_window_to_workspace = 4 }
    "comb1 + 6" = { move_window_to_workspace = 5 }
    "comb1 + 7" = { move_window_to_workspace = 6 }
    "comb1 + 8" = { move_window_to_workspace = 7 }
    "comb1 + 9" = { move_window_to_workspace = 8 }
    "comb1 + 0" = { move_window_to_workspace = 9 }

    "Alt + Tab" = "switch_to_last_workspace"
    "Alt + Shift + Left" = { join_window = "left" }
    "Alt + Shift + Right" = { join_window = "right" }
    "Alt + Shift + Up" = { join_window = "up" }
    "Alt + Shift + Down" = { join_window = "down" }
    "Alt + Comma" = "toggle_stack"
    "Alt + Slash" = "toggle_orientation"
    "Alt + Ctrl + E" = "unjoin_windows"
    "Alt + Shift + Space" = "toggle_window_floating"
    "Alt + F" = "toggle_fullscreen"
    "Alt + Shift + F" = "toggle_fullscreen_within_gaps"
    "comb1 + Ctrl + Space" = "toggle_focus_floating"
    "Alt + Shift + Equal" = "resize_window_grow"
    "Alt + Shift + Minus" = "resize_window_shrink"
    "Alt + Shift + D" = "debug"
    "Alt + Ctrl + S" = "serialize"
    "Alt + Ctrl + Q" = "save_and_exit"
  '';
}
