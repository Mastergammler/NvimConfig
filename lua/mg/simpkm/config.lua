local timer = require "mg.performance.timing"

local function read_vault_config(path)
    local config = {
        found = false,
        -- cwd = vault dir
        vault_root = ".",
        -- expecting bin path exec by default
        simpkm_exec = "pkmp",
        template_dir = "templates",
        daily_dir = "daily",
        daily_template = "",
        ticket_dir = "tickets",
        ticket_template = ""
    }

    local file, err = io.open(path, "r")
    if not file then
        return config, ("Cound not open config at path: %s"):format(err)
    end

    for line in file:lines() do
        -- trim
        line = line:match("^%s*(.-)%s*$")

        if line ~= "" and not line:match("^#") then
            local key, value = line:match("^([%w_%-]+)%s*=%s*(.+)$")
            if key and value then
                config[key] = value
            end
        end
    end

    file:close()
    config.found = true

    return config;
end

local config;
local path = ".vault"
local cfg, err = read_vault_config(path)

if not cfg.found then
    -- this opens a prompt in every project, which is annoying
    -- so i'll just omit this, and mke it a check command or something
    -- => like check_vault_info()
    --vim.notify(err, vim.log.levels.INFO)
end

config = cfg

return {
    load_config = read_vault_config,
    config = config
}
