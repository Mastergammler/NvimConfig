local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- FIXME: this is not working
local function nvim_api(opts)
    opts = opts or {}

    local results = {}

    -- vim.api functions
    for name in pairs(vim.api) do
        if type(vim.api[name]) == "function" then
            results[#results + 1] = {
                display = name,
                ordinal = name,
                value = name,
            }
        end
    end

    -- vim.* stdlib (top-level + one level of submodules)
    for mod_name, mod in pairs(vim) do
        if type(mod) == "table" and type(mod_name) == "string"
            and mod_name ~= "api" and mod_name ~= "uv" then
            for fn_name in pairs(mod) do
                if type(fn_name) == "string" and type(mod[fn_name]) == "function" then
                    results[#results + 1] = {
                        display = "vim." .. mod_name .. "." .. fn_name,
                        ordinal = mod_name .. "." .. fn_name,
                        value = "vim." .. mod_name .. "." .. fn_name,
                    }
                end
            end
        end
    end

    pickers.new(opts, {
        prompt_title = "Nvim API",
        finder = finders.new_table({ results = results }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                -- Open help for the function
                vim.cmd("help " .. entry.value:gsub("^vim\\.", ""))
            end)
            return true
        end,
    }):find()
end

--vim.keymap.set("n", "<leader>ha", nvim_api, { desc = "Nvim API" })
