-- TASKLIST: [2/5]
-- - handle link parsing with headers inside ('#my header')
-- - handle ==...== ***...*** blocks
-- ✔ todo/done cycling
-- - strikthrough done todos (& sub todos) -> different color etc
-- - own parser for markdown highlight classification

require "mg.simpkm.complete"

local jump = require "mg.simpkm.jump"
local fun = require "mg.simpkm.functions"
local template = require "mg.simpkm.template"
local tman = require "mg.simpkm.tman"
local daily = require "mg.simpkm.daily"

vim.keymap.set({ "n", "i" }, "<M-CR>", fun.cycle_bullet_todo, { desc = "[Markdown] Cycle bullet / todos" })
vim.keymap.set({ "n", "i" }, "<C-CR>", fun.cycle_bullet_todo, { desc = "[Markdown] Cycle bullet / todos" })
vim.keymap.set({ "n", "i" }, "<C-Space>", template.insert_template,
    { desc = "[Markdown] Teselcope open .vault template dir for insert" })
-- NOTE: Do NOT set space leader actions to insert mode, eles you produce lag!
-- (because nvim needs to wait for input shortcut combos)
vim.keymap.set({ "n" }, "<Space>nt", tman.new_ticket,
    { desc = "[Markdown] Create new ticket & parse default template" })
vim.keymap.set({ "n" }, "<M-d>", daily.open_daily,
    { desc = "[Markdown] Goto todays daily note" })
vim.keymap.set({ "n" }, "<M-p>", daily.prev_daily,
    { desc = "[Markdown] Goto prev daily note" })
vim.keymap.set({ "n" }, "<M-n>", daily.next_daily,
    { desc = "[Markdown] Goto next daily note" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(event)
        vim.keymap.set("n", "gf", jump.goto_link, {
            buffer = event.buf,
            desc = "[Markdown] Follow markdown links",
        })
    end,
})
