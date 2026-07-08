local cfg = require "mg.simpkm.config"
local actions = require "telescope.actions"
local actionState = require "telescope.actions.state"
local builtin = require "telescope.builtin"

-- TASKLIST: [3/4]
-- ✔ query template dir
-- x add to cmp source
-- ✔ telescope as picker
-- ✔ insert template (read file) on enter
-- - parse template text


-- @entry - telescope selet entry
local function parse_insert(templateDir, entry)
    local path = entry.path or (templateDir .. "/" .. entry.value)
    local lines = vim.fn.readfile(path)

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, lines)
end

local function insert_template(templateDir)
    builtin.find_files({
        cwd = templateDir,
        prompt_title = "Templates",
        attach_mappings = function(_, map)
            local function select_template(promptBufNr)
                local entry = actionState.get_selected_entry()
                actions.close(promptBufNr)

                if not entry then return end

                parse_insert(templateDir, entry)
            end

            map("i", "<CR>", select_template)
            map("N", "<CR>", select_template)

            return true
        end
    })
end

local function insert_action()
    insert_template(cfg.config.vault_root .. "/" .. cfg.config.template_dir)
end

--insert_action();

return {
    insert_template = insert_action
}
