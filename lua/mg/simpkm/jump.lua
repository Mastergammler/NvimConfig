local cfg = require "mg.simpkm.config"

local opt = {
    ext = ".md",
    base_path = vim.fn.getcwd() .. "/" .. cfg.config.vault_root,
    exec_path = cfg.config.simpkm_exec
}

local function get_link_under_cursor()
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local curCursor = { line = cursor[1], col = cursor[2] }

    local result = vim.system({
        opt.exec_path, "link",
        line, tostring(curCursor.col)
    }):wait()

    if result.code ~= 0 then
        vim.notify(result.stderr)
        return
    end

    local fields = vim.split(result.stdout, '\n', {
        plain = true,
        trimempty = false
    })

    local link = {
        found = fields[1] == "true",
        target = fields[2] .. opt.ext,
        alias = fields[3]
    }

    if link.found then
        local path = opt.base_path .. "/" .. link.target
        vim.cmd("edit " .. vim.fn.fnameescape(path))
    end
end

return {
    goto_link = get_link_under_cursor
}
