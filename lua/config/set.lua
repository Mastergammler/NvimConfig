vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.undofile = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.splitbelow = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- trigger for CursorHold events, currently not using it much
vim.opt.updatetime = 1000
vim.opt.colorcolumn = "120"
vim.opt.cursorline = true

-- without setting hegiht to 2 the 'type ENTER ..` prompt will always appear
-- and interrupt the startup flow
vim.opt.cmdheight = 2

-- enabeling copy paste by default
-- NOTE: requires a tool like xclip to be install on linux
vim.opt.clipboard:append('unnamed,unnamedplus')

-- we don't want to change the dir automatically everywhere
-- else the cmd of a new terminal will not be the root project dir
vim.opt.autochdir = false

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldtext = "getline(v:foldstart)"
-- loading large files gets very slow when we have fold enabled by default
-- therefore if you need fold use the 'zi' command to toggle it per buffer
vim.opt.foldenable = false
-- treating _ as a word separator as well
vim.opt.iskeyword:remove('_')

local util = require("mg.projectutil")

if util.is_windows() then
    vim.o.shell = "mgsh.exe"
end
