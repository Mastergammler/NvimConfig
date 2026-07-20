local cfg = require "mg.simpkm.config"

local function convert_obsidian_img_link(line)
    return line:gsub("!%[%[([^%]|]+)|?([^%]]*)%]%]", function(path, size)
        path = path:gsub(" ", "%%20")

        return "![" .. size .. "](" ..
            cfg.config.img_dir .. "/" .. path .. ".png)"
    end)
end

local function replace_image_link_under_cursor()
    local res = { found = false, line = vim.api.nvim_get_current_line() }

    if res.line:match("^!%[%[") then
        res.line = convert_obsidian_img_link(res.line)
        res.found = true
    end

    if res.found then
        local bufnr = vim.api.nvim_get_current_buf()
        local lineNum = vim.api.nvim_win_get_cursor(0)[1]

        vim.api.nvim_buf_set_lines(bufnr, lineNum - 1,
            lineNum, false, { res.line })
    end
end

return {
    to_md_image_link = replace_image_link_under_cursor
}
