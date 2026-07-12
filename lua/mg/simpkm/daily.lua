local template = require "mg.simpkm.template"
local date = require "mg.simpkm.date"
local cfg = require "mg.simpkm.config"
local fs = require "mg.fs"

local opt = {
    dir = cfg.from_relative(cfg.config.daily_dir),
    template_file = cfg.from_relative(cfg.config.template_dir .. "/" .. cfg.config.daily_template .. ".md"),
    extension = ".md"
}


-- TASKLIST: [2/2]
-- ✔ create note based on string date
-- ✔ create previous / next note functions
local function goto_daily(isoDate)
    local dailyNotePath = opt.dir .. "/" .. isoDate .. opt.extension

    if not fs.file_exists(dailyNotePath) then
        local lines = template.render_template(opt.template_file, { title = isoDate, date_iso = isoDate })
        vim.fn.writefile(lines, dailyNotePath)
    end

    vim.cmd.edit(vim.fn.fnameescape(dailyNotePath))
end

local function goto_daily_note()
    goto_daily(date.today())
end

local function prev_note()
    local curFile = vim.fn.expand("%:t:r")

    -- check if it's a daily note (meaning name = iso date)
    if curFile:match("^%d%d%d%d%-%d%d%-%d%d$") ~= nil then
        goto_daily(date.by_offset(curFile, -1))
    end
end

local function next_note()
    local curFile = vim.fn.expand("%:t:r")

    -- check if it's a daily note (meaning name = iso date)
    if curFile:match("^%d%d%d%d%-%d%d%-%d%d$") ~= nil then
        goto_daily(date.by_offset(curFile, 1))
    end
end

fs.ensure_dir(opt.dir)

return {
    open_daily = goto_daily_note,
    next_daily = next_note,
    prev_daily = prev_note
}
