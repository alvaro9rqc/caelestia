local desktop = require("utils.desktop")

-- Settings not exposed by hypr-vars.lua.
hl.config({ input = { kb_options = "compose:menu" } })

-- Vim-style directional focus.
for key, direction in pairs({ H = "left", J = "down", K = "up", L = "right" }) do
    hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = direction }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

-- HyprMod generates this file. It is optional during the first installation.
pcall(require, "hyprland-gui")

-- Keep Notion on the todo workspace even when launched outside the toggle.
desktop.window_rule("notion", "special:todo")
desktop.window_rule("whatsapp", "special:communication")

hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("hyprmod profile next"))

-- Lock session and turn off screen on CTRL + Escape (waits for lock animation to settle before DPMS off)
hl.bind("CTRL + Escape", function()
    hl.dispatch(hl.dsp.global("caelestia:lock"))
    hl.dispatch(hl.dsp.exec_cmd("caelestia-lock-screen"))
end)

------------------------------------------------------------------------
-- Monitor-Aware Independent Workspaces
------------------------------------------------------------------------
-- Strict monitor workspace rules:
-- Laptop display (eDP-1): workspaces 1..10
for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1", default = (i == 1) })
end

-- External monitor (HDMI-A-1): workspaces 11..20
for i = 11, 20 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1", default = (i == 11) })
end

-- Determine workspace offset based on the active monitor:
-- Laptop (eDP-1): offset 0 (workspaces 1..10)
-- External (HDMI-A-1): offset 10 (workspaces 11..20)
local function get_active_monitor_offset()
    local active_mon = hl.get_active_monitor()
    if not active_mon or active_mon.name == "eDP-1" then
        return 0
    end
    return 10
end

local function smart_ws_action(action, i)
    return function()
        local offset = get_active_monitor_offset()
        local target = offset + i

        if action == "move" then
            hl.dispatch(hl.dsp.window.move({ workspace = target }))
        elseif action == "move_silent" then
            hl.dispatch(hl.dsp.window.move({ workspace = target, follow = false }))
        else
            hl.dispatch(hl.dsp.focus({ workspace = target }))
        end
    end
end

-- Bind SUPER + 1..0, SUPER + SHIFT + 1..0, and SUPER + ALT + 1..0 dynamically per monitor
for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind("SUPER + " .. key, smart_ws_action("focus", i))
    hl.bind("SUPER + SHIFT + " .. key, smart_ws_action("move_silent", i))
    hl.bind("SUPER + ALT + " .. key, smart_ws_action("move", i))
end

-- Relative workspace cycling on current monitor (stays within 1..10 or 11..20)
local function smart_cycle_ws(step)
    return function()
        local ws = hl.get_active_workspace()
        if not ws then return end
        local id = ws.id
        if type(id) ~= "number" or id < 1 then
            id = 1
        end

        local offset = get_active_monitor_offset()
        local slot = (id - 1) % 10 + 1
        local new_slot = slot + step
        if new_slot > 10 then
            new_slot = 1
        elseif new_slot < 1 then
            new_slot = 10
        end

        hl.dispatch(hl.dsp.focus({ workspace = offset + new_slot }))
    end
end

local function smart_cycle_move(step)
    return function()
        local ws = hl.get_active_workspace()
        if not ws then return end
        local id = ws.id
        if type(id) ~= "number" or id < 1 then
            id = 1
        end

        local offset = get_active_monitor_offset()
        local slot = (id - 1) % 10 + 1
        local new_slot = slot + step
        if new_slot > 10 then
            new_slot = 1
        elseif new_slot < 1 then
            new_slot = 10
        end

        hl.dispatch(hl.dsp.window.move({ workspace = offset + new_slot, follow = false }))
    end
end

-- Cycle relative workspaces on current monitor (Arrows + Vim HJKL + Mouse wheel + Page Up/Down)
hl.bind("CTRL + SUPER + Left", smart_cycle_ws(-1), { repeating = true })
hl.bind("CTRL + SUPER + Right", smart_cycle_ws(1), { repeating = true })
hl.bind("CTRL + SUPER + H", smart_cycle_ws(-1), { repeating = true })
hl.bind("CTRL + SUPER + L", smart_cycle_ws(1), { repeating = true })
hl.bind("SUPER + mouse_up", smart_cycle_ws(-1))
hl.bind("SUPER + mouse_down", smart_cycle_ws(1))
hl.bind("SUPER + Page_Up", smart_cycle_ws(-1))
hl.bind("SUPER + Page_Down", smart_cycle_ws(1))

-- Move window across relative workspaces on current monitor
hl.bind("CTRL + SUPER + SHIFT + Left", smart_cycle_move(-1), { repeating = true })
hl.bind("CTRL + SUPER + SHIFT + Right", smart_cycle_move(1), { repeating = true })
hl.bind("CTRL + SUPER + SHIFT + H", smart_cycle_move(-1), { repeating = true })
hl.bind("CTRL + SUPER + SHIFT + L", smart_cycle_move(1), { repeating = true })
hl.bind("SUPER + ALT + mouse_up", smart_cycle_move(-1))
hl.bind("SUPER + ALT + mouse_down", smart_cycle_move(1))
hl.bind("SUPER + ALT + Page_Up", smart_cycle_move(-1))
hl.bind("SUPER + ALT + Page_Down", smart_cycle_move(1))

-- Special workspace transfer (Vim + Arrows)
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind("CTRL + SUPER + SHIFT + Up", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind("CTRL + SUPER + SHIFT + K", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind("CTRL + SUPER + SHIFT + Down", hl.dsp.window.move({ workspace = "e+0" }))
hl.bind("CTRL + SUPER + SHIFT + J", hl.dsp.window.move({ workspace = "e+0" }))

-- Cross-monitor navigation & window transfer (SUPER + O / SUPER + SHIFT + O)
hl.bind("SUPER + O", hl.dsp.focus({ monitor = "+1" }))
hl.bind("SUPER + SHIFT + O", hl.dsp.window.move({ monitor = "+1" }))


