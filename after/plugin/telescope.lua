local tele = require('telescope')
local builtin = require('telescope.builtin')
local todocomments = require('todo-comments')

tele.setup {
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = require('telescope.actions').move_selection_next,
                ["<C-k>"] = require('telescope.actions').move_selection_previous,
                -- TODO: do i use this?
                ["<C-x>"] = require('telescope.actions').select_default
            }
        },
        layout_config = {
            height = 0.95,
            width = 0.95,
            preview_width = 0.65
        },
        -- TODO: Configure this better, for right path bound etc
        path_display = { truncate = 3 }
    }
}

-----------------
-- FILE SEARCH --
-----------------

vim.keymap.set('n', "<leader>ff", function() builtin.find_files({ no_ignore = true }) end,
    { desc = 'Find files (working dir)' })
vim.keymap.set('n', "<leader><leader>", builtin.git_files, { desc = 'Find files (tracked by git)' })
-- TODO: check if i have overwritten this - not sure if i use this at all
vim.keymap.set('n', '<leader>rf', builtin.oldfiles, { desc = 'Find recent files' })

-------------------
-- SYMBOL SEARCH --
-------------------

vim.keymap.set('n', '<leader>lg', '<cmd>Telescope live_grep<cr>',
    { noremap = true, silent = true, desc = 'Live grep - Search string live (working dir)' })
--TODO: preview doesn't work, also doesn't only take working dir
vim.keymap.set('n', '<leader>ss', function() builtin.grep_string({ search = vim.fn.input("grep > ") }) end,
    { desc = 'Search string (working dir)' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search (current) word' })

vim.keymap.set('n', '<leader>/', function()
    -- FIXME: doesn't support layout config
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false
    })
end, { desc = '/ Fuzzily search in current buffer' })

-----------------
-- NVIm SEARCH --
-----------------

vim.keymap.set('n', '<leader>lb', builtin.buffers, { desc = 'List buffers' })
vim.keymap.set('n', '<leader>?', builtin.keymaps, { desc = 'Show all defined keymaps' })
vim.keymap.set('n', '<leader>hh', builtin.help_tags, { desc = 'Help documents' })

----------------
-- LSP SEARCH --
----------------

vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, { desc = 'List (document) symbols' })
-- TODO: can i refresh the whole project diagonstics before calling this?
vim.keymap.set('n', '<leader>ld', function() builtin.diagnostics({ line_width = 18 }) end, { desc = 'List diagnostics' })
vim.keymap.set('n', '<leader>le', function() builtin.diagnostics({ line_width = 18, severity_limit = 1 }) end,
    { desc = 'List errors' })
vim.keymap.set('n', '<leader>rr', function() builtin.lsp_references({ show_line = false, trim_text = true }) end,
    { desc = 'List refereces' })
-- TODO: prefilter this via options?
vim.keymap.set('n', '<leader>ws', function() builtin.lsp_dynamic_workspace_symbols() end,
    { desc = 'List workspace symbols (whole project)' })
vim.keymap.set('n', '<leader>td', function() builtin.lsp_type_definitions() end, { desc = 'List workspace types' })


---------------------
--  OTHER PLUGINS  --
---------------------

vim.keymap.set('n', "<leader>lt", ":TodoTelescope<CR>",
    { desc = "list todos -  lists all todos (unfiltered by type)" })
-- FIXME: these don't work? Not sure why they don't
vim.keymap.set('n', "<leader>tn", function() todocomments.jump_next() end, { desc = "todo next - jump to next todo" })
vim.keymap.set('n', "<leader>tp", function() todocomments.jump_prev() end,
    { desc = "todo previous - jump to previous todo" })
