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
-- Automatically set secondary monitors to decade 1 (workspace 11)
-- without static workspace rules, keeping windows fully moveable across screens
local function setup_secondary_monitors()
    local mons = hl.get_monitors()
    if #mons > 1 then
        for _, m in ipairs(mons) do
            if m.name ~= "eDP-1" then
                if m.active_workspace and m.active_workspace.id < 11 then
                    hl.dispatch(hl.dsp.focus({ monitor = m.name }))
                    hl.dispatch(hl.dsp.focus({ workspace = 11 }))
                end
            end
        end
    end
end

setup_secondary_monitors()

hl.on("monitor.added", function(data)
    local name = (type(data) == "table" or type(data) == "userdata") and data.name or tostring(data)
    if name and name ~= "" and name ~= "eDP-1" then
        hl.dispatch(hl.dsp.focus({ monitor = name }))
        hl.dispatch(hl.dsp.focus({ workspace = 11 }))
    end
end)

-- Cross-monitor navigation & window transfer (SUPER + O / SUPER + SHIFT + O)
hl.bind("SUPER + O", hl.dsp.focus({ monitor = "+1" }))
hl.bind("SUPER + SHIFT + O", hl.dsp.window.move({ monitor = "+1" }))



