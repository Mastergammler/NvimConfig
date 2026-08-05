local cfg = require "mg.simpkm.config"
local actions = require "telescope.actions"
local actionState = require "telescope.actions.state"
local builtin = require "telescope.builtin"
local date = require "mg.simpkm.date"

-- TASKLIST: [4/4]
-- ✔ query template dir
-- x add to cmp source
-- ✔ telescope as picker
-- ✔ insert template (read file) on enter
-- ✔ parse template text

-- sitting context dependent and general functions
-- everything that is not specific comes from the context
-- all others are generally callable functions
local SUB_FNS = {
    title = function(ctx) return ctx.title end,
    ticket_no = function(ctx) return ctx.no end,
    today = function(_) return date.today() end,
    now = function(_) return date.now() end,
    yesterday = function(_) return date.yesterday() end,
    tomorrow = function(_) return date.tomorrow() end,
    prev_date = function(ctx) return date.by_offset(ctx.date_iso, -1) end,
    next_date = function(ctx) return date.by_offset(ctx.date_iso, 1) end,
    cw = function(ctx) return date.cw(ctx.date_iso) end,
    year_short = function(ctx) return date.year_short(ctx.date_iso) end
};

local function substitute_template(templatePath, ctx)
    if not vim.uv.fs_stat(templatePath) then return {} end

    local templateLines = vim.fn.readfile(templatePath)
    for i, line in ipairs(templateLines) do
        templateLines[i] = line:gsub("<%%%s*(.-)%s*%%>", function(key)
            local fn = SUB_FNS[key]
            if fn then
                return fn(ctx)
            end

            return "<%" .. key .. "%>"
        end)
    end

    return templateLines
end

-- @entry - telescope select entry
local function parse_insert(templateDir, entry)
    local path = entry.path or (templateDir .. "/" .. entry.value)

    local ctx = {}
    ctx.title = vim.fn.expand("%:t:r")
    local lines = substitute_template(path, ctx)

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

return {
    insert_template = insert_action,
    render_template = substitute_template
}
