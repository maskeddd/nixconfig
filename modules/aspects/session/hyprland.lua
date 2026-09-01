local mod = "SUPER"
local terminal = "ghostty"
local menu = "noctalia msg panel-toggle launcher"
local files = "nautilus"
local lock = "hyprlock"

local function after_tray_ready(command)
    return "gdbus wait --session org.kde.StatusNotifierWatcher && exec " .. command
end

hl.monitor({
    output = "DP-2",
    mode = "2560x1440@120",
    position = "0x0",
    scale = 1,
    transform = 1,
})

hl.monitor({
    output = "DP-3",
    mode = "2560x1440@300",
    position = "1440x560",
    scale = 1,
})

hl.config({
    input = {
        accel_profile = "flat",
        sensitivity = -0.3,
    },

    cursor = {
        enable_hyprcursor = false,
    },

    general = {
        gaps_out = 10,
        gaps_workspaces = 20,
        border_size = 3,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 1,
        disable_splash_rendering = true,
        focus_on_activate = true,
        vrr = 2,
    },

    decoration = {
        shadow = {
            enabled = false,
        },
        blur = {
            enabled = false,
        },
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float())
hl.bind(mod .. " + E", hl.dsp.exec_cmd(files))
hl.bind(mod .. " + L", hl.dsp.exec_cmd(lock))
hl.bind("Print",
    hl.dsp.exec_cmd(
        [[grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" -t ppm - | satty --filename -]]))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" -t ppm - | satty --filename -'))
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + SHIFT + LEFT", hl.dsp.workspace.move({ monitor = "+1" }))
hl.bind(mod .. " + SHIFT + RIGHT", hl.dsp.workspace.move({ monitor = "-1" }))
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "d" }))

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

for workspace = 1, 9 do
    local keycode = workspace + 9
    hl.bind(mod .. " + code:" .. keycode, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mod .. " + SHIFT + code:" .. keycode, hl.dsp.window.move({ workspace = workspace, follow = true }))
end

hl.layer_rule({
    name = "no-anim-for-selection",
    match = { namespace = "selection" },
    no_anim = true,
})

hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})
hl.window_rule({ match = { class = "^(helium)$" }, workspace = "1" })
hl.window_rule({ match = { class = "^(vesktop)$" }, workspace = "4" })
hl.window_rule({ match = { class = "^(spotify)$" }, workspace = "4" })
hl.window_rule({ match = { class = "^(steam)$" }, workspace = "3" })
hl.window_rule({ match = { class = [[^org\.gnome\.NautilusPreviewer$]] }, float = true })
hl.window_rule({ match = { class = "^(osu!)$" }, content = "game" })

hl.workspace_rule({ workspace = "1", monitor = "DP-3" })
hl.workspace_rule({ workspace = "2", monitor = "DP-3" })
hl.workspace_rule({ workspace = "3", monitor = "DP-3" })
hl.workspace_rule({ workspace = "4", monitor = "DP-2" })

hl.on("hyprland.start", function()
    hl.exec_cmd("sunsetr")
    hl.exec_cmd("steam -silent")
    hl.exec_cmd(after_tray_ready("1password --silent"))
    hl.exec_cmd("helium", { workspace = "1 silent" })
    hl.exec_cmd(after_tray_ready("vesktop"), { workspace = "4 silent" })
    hl.exec_cmd("spotify", { workspace = "4 silent" })
end)
