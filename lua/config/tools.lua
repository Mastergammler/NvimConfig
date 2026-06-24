local ctools = require 'mg.c.modularizer'
local utils = require 'mg.utils'
ctools = utils.reload_module('mg.c.modularizer')

vim.keymap.set("n", "<leader>co", function()
        ctools.add_import("compile.cpp", "#include \"%s\"")
    end,
    { noremap = true, desc = '[compile] Adds the current file as include to next compile.cpp' })

vim.keymap.set("n", "<leader>in", function()
        ctools.add_fn_to("internal.h")
    end,
    { noremap = true, desc = '[internal] Add (c/cpp) function under cursor to internal' })

vim.keymap.set("n", "<leader>pu", function()
        ctools.add_header_fn()
    end,
    { noremap = true, desc = '[public] Add (c/cpp) function to header matching parent dir (module.h fallback)' })
