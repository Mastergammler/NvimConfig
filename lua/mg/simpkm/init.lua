-- TASKLIST: [1/5]
-- - handle link parsing with headers inside ('#my header')
-- - handle ==...== ***...*** blocks
-- ✔ todo/done cycling
-- - strikthrough done todos (& sub todos) -> different color etc
-- - own parser for markdown highlight classification

require "mg.simpkm.complete"

local jump = require "mg.simpkm.jump"
local fun = require "mg.simpkm.functions"

vim.keymap.set({ "n", "i" }, { "<C-CR>", "<M-CR>" }, fun.cycle_bullet_todo, { desc = "[Markdown] Cycle bullet / todos" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(event)
        vim.keymap.set("n", "gf", jump.goto_link, {
            buffer = event.buf,
            desc = "[Markdown] Follow markdown links",
        })
    end,
})
