local timer = require "mg.performance.timing"

local function read_vault_config(path)
    local config = {
        found = false,
        -- cwd = vault dir
        vault_root = ".",
        -- expecting bin path exec by default
        simpkm_exec = "pkmp",
        template_dir = "templates"
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
    print(err)
end

config = cfg

return {
    load_config = read_vault_config,
    config = config
}
