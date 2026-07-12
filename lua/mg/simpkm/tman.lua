-- NOTE: restart nvim if new settings where added!
--local utils = require 'mg.utils'
--template = utils.reload_module('mg.simpkm.template')
--
local cfg = require "mg.simpkm.config"
local template = require "mg.simpkm.template"
local fs = require "mg.fs"

local opt = {
    ext = ".md",
    ticket_dir = vim.fn.getcwd() .. "/" .. cfg.config.vault_root .. "/" .. cfg.config.ticket_dir,
    ticket_template_file = cfg.config.vault_root ..
        "/" .. cfg.config.template_dir .. "/" .. cfg.config.ticket_template .. ".md",
}

local function next_ticket_number()
    local res = { ok = false, number = 1 }
    local files = vim.fn.globpath(opt.ticket_dir, "*" .. opt.ext, false, true)

    if #files == 0 then
        res.ok = true
        return res
    end

    -- globpath() returns the files in lexical order
    local last = vim.fn.fnamemodify(files[#files], ":t:r")
    res.number = tonumber(last:match("^⮜%s*(%d+)%s*⮞"))

    if res.number then
        res.ok = true
        res.number = res.number + 1
    else
        vim.notify(string.format("Unable to parse number form '%s'", last), vim.log.levels.ERROR)
    end

    return res
end

local function new_ticket()
    vim.ui.input({ prompt = "Ticket name: " }, function(title)
        if not title or title == "" then return end

        local numRes = next_ticket_number()
        if not numRes.ok then return end

        local filename = string.format("⮜ %03d ⮞  %s" .. opt.ext, numRes.number, title)
        local path = opt.ticket_dir .. "/" .. filename
        local lines = template.render_template(opt.ticket_template_file, { title = title, no = numRes.number })

        vim.fn.writefile(lines, path)
        vim.cmd.edit(vim.fn.fnameescape(path))
    end)
end

fs.ensure_dir(opt.ticket_dir)

return {
    new_ticket = new_ticket
}
