local ctools = require 'mg.c.modularizer'
--local utils = require 'mg.utils'
--ctools = utils.reload_module('mg.c.modularizer')

vim.keymap.set("n", "<leader>im", function()
        ctools.add_import("compile.cpp", "#include \"%s\"")
    end,
    { noremap = true, desc = 'Adds the current file as include to next compile.cpp' })
