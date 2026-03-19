local ctools = require 'mg.c.modularizer'
local utils = require 'mg.utils'
ctools = utils.reload_module('mg.c.modularizer')

vim.keymap.set("n", "<leader>im", function()
        ctools.add_import("compile.cpp", "#include \"%s\"")
    end,
    { noremap = true, desc = 'Adds the current file as include to next compile.cpp' })

vim.keymap.set("n", "<leader>in", function()
        ctools.add_fn_to("internal.h")
    end,
    { noremap = true, desc = 'Add (c) function under cursor to internal' })

vim.keymap.set("n", "<leader>he", function()
        ctools.add_header_fn()
    end,
    { noremap = true, desc = 'Add (c) function to header matching parent dir' })
