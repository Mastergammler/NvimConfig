local tele = require('telescope')
local builtin = require('telescope.builtin')

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
