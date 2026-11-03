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

-- Lock session and turn off screen on CTRL + Escape (wakes immediately on user interaction)
hl.bind("CTRL + Escape", function()
    hl.dispatch(hl.dsp.global("caelestia:lock"))
    hl.dispatch(hl.dsp.dpms("off"))
end)

