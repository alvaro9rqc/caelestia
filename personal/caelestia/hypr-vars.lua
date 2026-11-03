return {
    browser                = "brave",
    editor                 = "foot $HOME/.local/share/bob/nvim-bin/nvim",

    -- System & Session
    kbSleep                = "SUPER + Escape",
    kbLock                 = "", -- Bound in hypr-user.lua to lock + dpms off
    kbRestoreLock          = "CTRL + SUPER + ALT + L",
    kbShowPanels           = "CTRL + SUPER + P",

    -- Workspaces: disabled here so keybinds.lua doesn't create duplicate binds.
    -- All workspace focus, move, and vim-style navigation are managed in hypr-user.lua.
    kbGoToWs               = "",
    kbGoToWsGroup          = "",
    kbMoveWinToWs          = "",
    kbMoveWinToWsSilent    = "",
    kbMoveWinToWsGroup     = "",
    kbNextWs               = "",
    kbPrevWs               = "",
    kbMoveWinToWsNext      = "",
    kbMoveWinToWsPrev      = "",
    kbNextWsGroup          = "",
    kbPrevWsGroup          = "",
    kbMoveWinToWsSpecial   = "",
    kbMoveWinFromWsSpecial = "",

    -- Window resizing (Arrows + Vim HJKL)
    kbWindowDecreaseWidth  = { "SUPER + Minus", "SUPER + ALT + Left", "SUPER + ALT + H" },
    kbWindowIncreaseWidth  = { "SUPER + Equal", "SUPER + ALT + Right", "SUPER + ALT + L" },
    kbWindowDecreaseHeight = { "SUPER + SHIFT + Minus", "SUPER + ALT + Up", "SUPER + ALT + K" },
    kbWindowIncreaseHeight = { "SUPER + SHIFT + Equal", "SUPER + ALT + Down", "SUPER + ALT + J" },
}
