local term = "footclient"
local file = "thunar"
local web = "firefox"
local menu = "fuzzel"
local bar = "waybar"
local lock = "hyprlock"

local mod = "SUPER"
local mod_a = mod .. " + ALT"
local mod_c = mod .. " + CTRL"
local mod_s = mod .. " + SHIFT"


hl.bind(mod .. " + C",
  hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu -d $'\t' --with-nth 2 | cliphist decode | wl-copy"))

hl.bind(mod .. " + W", hl.dsp.exec_cmd(term .. " -e " .. "active-windows"))


hl.bind(mod .. " + M", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd(term .. " -e " .. "bluetooth-menu"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd(term .. " -e " .. "network-menu"))
hl.bind(mod .. " + O", hl.dsp.exec_cmd(term .. " -e " .. "power-menu"))

hl.bind(mod .. " + U", hl.dsp.exec_cmd(term .. " -e " .. "system-update"))

hl.bind("CTRL" .. " + SHIFT + " .. "S", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind("PRINT", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"))

hl.bind(mod_s .. " + Backspace", hl.dsp.exec_cmd("noctalia msg session lock-and-suspend"))
hl.bind(mod .. " + Backspace", hl.dsp.exec_cmd("noctalia msg session lock"))

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(term))
hl.bind(mod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + S", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
hl.bind(mod .. " + F", hl.dsp.exec_cmd(web))
hl.bind("ALT" .. " + F", hl.dsp.exec_cmd(web .. " --private-window "))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(file))

local closeWindowBind = hl.bind(mod .. " + Q", hl.dsp.window.close())
local fullscreenWindowBind = hl.bind("ALT" .. " + RETURN",
  hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))

-- Move focus with mod + arrow keys
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Scroll through existing workspaces with mod + scroll
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
-- Move/resize windows with mod + LMB/RMB and dragging
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Example special workspace (scratchpad)
-- hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Switch workspaces with mod + [0-9]
-- Move active window to a workspace with mod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end


-- Laptop multimedia keys for volume and LCD brightness
hl.bind("F3", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("F2", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("F1", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true })
hl.bind("F4", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true })
hl.bind("F8", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("F7", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
