return {
    browser                = "brave",
    editor                 = "foot $HOME/.local/share/bob/nvim-bin/nvim",

    -- System & Session
    kbSleep                = "SUPER + Escape",
    kbLock                 = "", -- Bound in hypr-user.lua to lock + dpms off
    kbRestoreLock          = "CTRL + SUPER + ALT + L",
    kbShowPanels           = "CTRL + SUPER + P",

    -- Workspaces navigation (Arrows + Vim HJKL)
    kbNextWs               = { "SUPER + mouse_down", "CTRL + SUPER + Right", "SUPER + Page_Down", "CTRL + SUPER + L" },
    kbPrevWs               = { "SUPER + mouse_up", "CTRL + SUPER + Left", "SUPER + Page_Up", "CTRL + SUPER + H" },

    -- Move windows across workspaces (Arrows + Vim HJKL)
    kbMoveWinToWsNext      = { "SUPER + ALT + mouse_down", "SUPER + ALT + Page_Down", "CTRL + SUPER + SHIFT + Right", "CTRL + SUPER + SHIFT + L" },
    kbMoveWinToWsPrev      = { "SUPER + ALT + mouse_up", "SUPER + ALT + Page_Up", "CTRL + SUPER + SHIFT + Left", "CTRL + SUPER + SHIFT + H" },
    kbMoveWinToWsSpecial   = { "SUPER + ALT + S", "CTRL + SUPER + SHIFT + Up", "CTRL + SUPER + SHIFT + K" },
    kbMoveWinFromWsSpecial = { "CTRL + SUPER + SHIFT + Down", "CTRL + SUPER + SHIFT + J" },

    -- Window resizing (Arrows + Vim HJKL)
    kbWindowDecreaseWidth  = { "SUPER + Minus", "SUPER + ALT + Left", "SUPER + ALT + H" },
    kbWindowIncreaseWidth  = { "SUPER + Equal", "SUPER + ALT + Right", "SUPER + ALT + L" },
    kbWindowDecreaseHeight = { "SUPER + SHIFT + Minus", "SUPER + ALT + Up", "SUPER + ALT + K" },
    kbWindowIncreaseHeight = { "SUPER + SHIFT + Equal", "SUPER + ALT + Down", "SUPER + ALT + J" },
}
