local function directory()
    local root = vim.fn.getcwd()
    local path = vim.fn.expand('%:h')
    if path == '.' or path == root then return '' end
    if string.match(path, "^term:?") then return "terminal" end
    return path
end

require("lualine").setup({
    sections = {
        lualine_b = { { "branch", "diff" }, directory },
        lualine_c = { { "filename", path = 0 } }
    },
    inactive_sections = {
        lualine_c = { { "filename", path = 1 } }
    }
})
