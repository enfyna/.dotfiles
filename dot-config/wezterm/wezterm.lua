-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Start Full Screen
wezterm.on('window-config-reloaded', function(window, _)
    -- approximately identify this gui window, by using the associated mux id
    local id = tostring(window:window_id())

    -- maintain a mapping of windows that we have previously seen before in this event handler
    local seen = wezterm.GLOBAL.seen_windows or {}
    -- set a flag if we haven't seen this window before
    local is_new_window = not seen[id]
    -- and update the mapping
    seen[id] = true
    wezterm.GLOBAL.seen_windows = seen

    -- now act upon the flag
    if is_new_window then
        window:toggle_fullscreen()
        window:focus()
    end
end)

-- X11
config.enable_wayland = false

config.warn_about_missing_glyphs = false

config.window_decorations = "NONE"
config.hide_mouse_cursor_when_typing = true

config.color_scheme = 'Windows NT (base16)'
config.inactive_pane_hsb = {
    saturation = 0.0,
    brightness = 0.1,
}
config.colors = {
    cursor_bg = '#cccccc'
}
config.enable_tab_bar = false
config.font_size = 16.0
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- config.leader = { key = 'a', mods = 'CTRL' }
config.keys = {
    {
        key = "Backspace",
        mods = "CTRL|SHIFT",
        action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "Enter",
        mods = "CTRL|SHIFT",
        action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = 'U',
        mods = 'CTRL|SHIFT',
        action = act.ActivatePaneDirection 'Next'
    },
    {
        key = "F",
        mods = 'CTRL|SHIFT',
        action = act.PaneSelect {
            mode = 'SwapWithActiveKeepFocus',
            alphabet = '1234567890',
        },
    },
    {
        key = 'H',
        mods = 'CTRL|SHIFT',
        action = act.AdjustPaneSize { 'Left', 1 },
    },
    {
        key = 'J',
        mods = 'CTRL|SHIFT',
        action = act.AdjustPaneSize { 'Down', 1 },
    },
    {
        key = 'K',
        mods = 'CTRL|SHIFT',
        action = act.AdjustPaneSize { 'Up', 1 }
    },
    {
        key = 'L',
        mods = 'CTRL|SHIFT',
        action = act.AdjustPaneSize { 'Right', 1 },
    },
    {
        key = ':',
        mods = 'SHIFT|CTRL',
        action = act.ActivateCopyMode
    },
    {
        key = "D",
        mods = 'CTRL|SHIFT',
        action = wezterm.action_callback(function(_, pane)
            local tab = pane:tab()
            local panes = tab:panes_with_info()
            if #panes == 1 then
                pane:split({
                    direction = "Bottom",
                    size = 0.2,
                })
            elseif not panes[1].is_zoomed then
                panes[1].pane:activate()
                tab:set_zoomed(true)
            elseif panes[1].is_zoomed then
                tab:set_zoomed(false)
                panes[2].pane:activate()
            end
        end),
    },
    {
        key = 'Q',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.EmitEvent 'set-bg-image'
    },
    {
        key = 'W',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.EmitEvent 'clear-bg-image'
    },
}

local images_directory = "/home/oem/.config/kitty/wallpapers/"

local function get_random_image()
    local handle = io.popen('find "' ..
        images_directory .. '" -type f \\( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \\) | shuf -n 1')
    if handle == nil then
        return ""
    end
    local result = handle:read("*a")
    handle:close()

    return result:gsub("%s+$", "")
end

wezterm.on('set-bg-image', function(window, _)
    local overrides = window:get_config_overrides() or {}
    overrides.background = {
        {
            source = {
                File = get_random_image()
            },
            hsb = {
                brightness = 0.03
            },
            height = "Cover",
            repeat_y = "NoRepeat",
            vertical_align = "Middle",
            horizontal_align = "Center",
        }
    }
    window:set_config_overrides(overrides)
end)

wezterm.on('clear-bg-image', function(window, _)
    local overrides = window:get_config_overrides() or {}
    overrides.background = {
        {
            source = {
                Color = "black"
            },
        }
    }
    window:set_config_overrides(overrides)
end)

-- and finally, return the configuration to wezterm
return config
