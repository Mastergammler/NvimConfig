local timer = require "mg.performance.timing"

local opt = {
    ext = ".md",
    base_path = vim.fn.getcwd(),
    exec_path = vim.env.HOME .. "/02-areas/simpkm/parser/.build/pkmp"
}

-- TODO: for testing only
-- opt.base_path = vim.fn.expand("%:p:h")

local function get_link_under_cursor()
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local curCursor = { line = cursor[1], col = cursor[2] }

    local result = vim.system({ opt.exec_path, line, tostring(curCursor.col) }):wait()

    if result.code ~= 0 then
        vim.notify(result.stderr)
        return
    end

    local fields = vim.split(result.stdout, '\n', { plain = true, trimempty = false })

    local link = {
        found = fields[2] == "true",
        target = fields[3] .. opt.ext,
        alias = fields[4]
    }

    if link.found then
        local path = opt.base_path .. "/" .. link.target
        vim.cmd("edit " .. vim.fn.fnameescape(path))
    end
end

-- this is for testing [[my link yay|with a freaking alias!]]
-- not a real link [other link stuff]

--timer.measure(get_link_under_cursor)
--get_link_under_cursor()

vim.keymap.set("n", "<leader>gc", function()
    vim.cmd("w")
    get_link_under_cursor();
end, { desc = "go command!!!! - runs a test function somewhere" });

return {
    goto_link = get_link_under_cursor
}
