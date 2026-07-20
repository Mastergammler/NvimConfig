-- TASKLIST: [2/5]
-- - handle link parsing with headers inside ('#my header')
-- - handle ==...== ***...*** blocks
-- ✔ todo/done cycling
-- - strikthrough done todos (& sub todos) -> different color etc
-- - own parser for markdown highlight classification

local complete = require "mg.simpkm.complete"
local jump = require "mg.simpkm.jump"
local fun = require "mg.simpkm.functions"
local template = require "mg.simpkm.template"
local tman = require "mg.simpkm.tman"
local daily = require "mg.simpkm.daily"
local timer = require "mg.performance.timing"
local image = require "mg.simpkm.image"

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
vim.keymap.set({ "n" }, "<M-r>i", complete.regenerate_index,
    { desc = "[PKM] Recreate the index" })
vim.keymap.set({ "n" }, "<M-i>",
    function()
        timer.measure("Refreshed index in ", complete.reload_index)
    end,
    { desc = "[PKM] Refresh the index from the index file" })
vim.keymap.set("n", "<M-r>l", image.to_md_image_link,
    { desc = "[PKM] Convert obsidian (image) link to md link" })



local ns = vim.api.nvim_create_namespace("markdown_line_limit")

local function set_line_limit(event)
    -- custom styling if wanted
    vim.api.nvim_set_hl(0, "LineLimit", {
        fg = "#ff8800",
        bold = true,
    })
    local text = " Page End "
    local width = 80
    local pad = math.floor((width - #text) / 2)
    local line =
        string.rep("-", pad) .. text ..
        string.rep("-", width - pad - #text)

    local maxLine = vim.api.nvim_buf_line_count(event.buf)
    local printLine = 60

    if maxLine >= printLine then
        local id = vim.api.nvim_buf_set_extmark(event.buf, ns, printLine, 0, {
            virt_lines = {
                { { line, "Comment" } },
            },
            virt_lines_above = true,
        })
    end
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(event)
        vim.keymap.set("n", "gf", jump.goto_link, {
            buffer = event.buf,
            desc = "[Markdown] Follow markdown links",
        })
    end,
})
vim.api.nvim_create_autocmd({ "fileType", "BufEnter", "TextChanged", "TextChangedI" }, {
    pattern = "markdown",
    callback = function(event)
        vim.api.nvim_buf_clear_namespace(event.buf, ns, 0, -1)
        set_line_limit(event)
    end,
})
