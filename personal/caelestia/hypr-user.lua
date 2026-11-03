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
-- Multi-Monitor Support (Flexible & Native Caelestia Decades)
------------------------------------------------------------------------
-- Automatically assign each external monitor its own decade:
-- 2nd monitor -> workspace 11 (decade 11..20)
-- 3rd monitor -> workspace 21 (decade 21..30), etc.
local function setup_secondary_monitors()
    local mons = hl.get_monitors()
    if #mons > 1 then
        local ext_idx = 1
        for _, m in ipairs(mons) do
            if m.name ~= "eDP-1" then
                local target_ws = ext_idx * 10 + 1
                if m.active_workspace and m.active_workspace.id < 11 then
                    hl.dispatch(hl.dsp.focus({ monitor = m.name }))
                    hl.dispatch(hl.dsp.focus({ workspace = target_ws }))
                end
                ext_idx = ext_idx + 1
            end
        end
    end
end

setup_secondary_monitors()

hl.on("monitor.added", function(data)
    local name = (type(data) == "table" or type(data) == "userdata") and data.name or tostring(data)
    if name and name ~= "" and name ~= "eDP-1" then
        local mons = hl.get_monitors()
        local ext_count = 0
        for _, m in ipairs(mons) do
            if m.name ~= "eDP-1" then
                ext_count = ext_count + 1
            end
        end
        local target_ws = math.max(1, ext_count) * 10 + 1
        hl.dispatch(hl.dsp.focus({ monitor = name }))
        hl.dispatch(hl.dsp.focus({ workspace = target_ws }))
    end
end)

-- Cross-monitor navigation (focus other monitor)
hl.bind("SUPER + O", hl.dsp.focus({ monitor = "+1" }))




