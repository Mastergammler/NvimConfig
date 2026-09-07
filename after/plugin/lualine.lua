local utils = require 'mg.utils'

local function directory()
    local root = vim.fn.getcwd()
    local path = vim.fn.expand('%:h')
    if path == '.' or path == root then return '' end
    if string.match(path, "^term:?") then return "terminal" end
    return path
end

local function is_text_file()
    local ft = vim.bo.filetype
    return ft == 'markdown' or ft == 'text' or ft == 'asciidoc'
end

-- { "filename" , path = 1 } somtimes prepends a ./
local function filename()
    local path = vim.fn.expand("%:.")
    return path:gsub("^%./", "")
end

require("lualine").setup({
    sections = {
        lualine_b = { filename },
        lualine_c = {},
        lualine_y = { { utils.wordcount, cond = is_text_file }, { 'progress', cond = function() return not is_text_file() end } },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_c = { { "filename", path = 1 } }
    }
})
