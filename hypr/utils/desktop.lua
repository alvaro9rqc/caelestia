local json = require("utils.json")

local home        = os.getenv("HOME")
local config_home = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
local data_home   = os.getenv("XDG_DATA_HOME") or (home .. "/.local/share")
local registry    = config_home .. "/caelestia/desktop-apps.local.json"

local function read_file(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end

local function load_registry()
    local content = read_file(registry)
    if not content then return {} end

    local ok, decoded = pcall(json.decode, content)
    if ok and type(decoded) == "table" then return decoded end
    return {}
end

local function expand_path(path)
    if type(path) ~= "string" then return nil end
    path = path:gsub("^~", home)
    path = path:gsub("%${HOME}", home):gsub("%$HOME", home)
    path = path:gsub("%${XDG_DATA_HOME}", data_home):gsub("%$XDG_DATA_HOME", data_home)
    return path
end

local function file_exists(path)
    local file = path and io.open(path, "r")
    if not file then return false end
    file:close()
    return true
end

local function desktop_dirs()
    local dirs = { data_home .. "/applications" }
    local system_dirs = os.getenv("XDG_DATA_DIRS") or "/usr/local/share:/usr/share"
    for dir in system_dirs:gmatch("[^:]+") do
        dirs[#dirs + 1] = dir .. "/applications"
    end
    return dirs
end

local function resolve_path(value)
    value = expand_path(value)
    if not value then return nil end
    if value:sub(1, 1) == "/" and file_exists(value) then return value end

    for _, dir in ipairs(desktop_dirs()) do
        local path = dir .. "/" .. value
        if file_exists(path) then return path end
    end
end

local function parse_desktop(path)
    local content = read_file(path)
    if not content then return nil end

    local entry = {}
    local in_desktop_entry = false
    for line in content:gmatch("[^\r\n]+") do
        local section = line:match("^%s*%[([^]]+)%]%s*$")
        if section then
            if in_desktop_entry then break end
            in_desktop_entry = section == "Desktop Entry"
        elseif in_desktop_entry then
            local key, value = line:match("^%s*([%w]+)%s*=%s*(.-)%s*$")
            if key and value then entry[key] = value end
        end
    end

    local exec = entry.Exec or ""
    local app_id = exec:match("%-%-app%-id%s*=%s*([^%s\"']+)")
        or exec:match("%-%-app%-id%s+([^%s\"']+)")

    return {
        path = path,
        name = entry.Name,
        app_id = app_id,
        startup_wm_class = entry.StartupWMClass,
    }
end

local function append_unique_match(matches, value)
    if not value or value == "" then return end
    for _, match in ipairs(matches) do
        if match.class == value then return end
    end
    matches[#matches + 1] = { class = value }
end

local function metadata(alias)
    local value = load_registry()[alias]
    if type(value) == "table" then value = value.desktop or value.path end
    local path = resolve_path(value)
    return path and parse_desktop(path) or nil
end

local function resolve(config)
    local bindings = load_registry()

    for _, apps in pairs(config) do
        if type(apps) == "table" then
            for _, app in pairs(apps) do
                if type(app) == "table" and type(app.desktop) == "string" then
                    local alias = app.desktop
                    local value = bindings[alias]
                    if type(value) == "table" then value = value.desktop or value.path end

                    local path = resolve_path(value)
                    local meta = path and parse_desktop(path) or nil
                    local matches = app.match or {}
                    if meta then
                        append_unique_match(matches, meta.app_id)
                        append_unique_match(matches, meta.startup_wm_class)
                    end

                    app.match = matches
                    app.command = { "caelestia-desktop", "launch", alias }
                end
            end
        end
    end

    return config
end

local function regex_escape(value)
    local special = {
        ["\\"] = true, ["."] = true, ["^"] = true, ["$"] = true,
        ["|"] = true, ["?"] = true, ["*"] = true, ["+"] = true,
        ["("] = true, [")"] = true, ["["] = true, ["]"] = true,
        ["{"] = true, ["}"] = true,
    }
    local escaped = {}
    for index = 1, #value do
        local char = value:sub(index, index)
        escaped[#escaped + 1] = special[char] and ("\\" .. char) or char
    end
    return table.concat(escaped)
end

local function window_rule(alias, workspace)
    local meta = metadata(alias)
    if not meta then return false end

    local values = {}
    if meta.app_id then values[#values + 1] = meta.app_id end
    if meta.startup_wm_class and meta.startup_wm_class ~= meta.app_id then
        values[#values + 1] = meta.startup_wm_class
    end

    for _, value in ipairs(values) do
        hl.window_rule({
            match = { class = ".*" .. regex_escape(value) .. ".*" },
            workspace = workspace,
        })
    end

    return #values > 0
end

return {
    metadata = metadata,
    resolve = resolve,
    window_rule = window_rule,
}
