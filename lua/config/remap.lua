local refactor = require 'mg.refactoring.refactoringutil'
local tlist = require 'mg.tman.tasklist'
local cref = require 'mg.c.refactor'

local save =
    function()
        vim.lsp.buf.format()
        vim.cmd.update()
    end
vim.keymap.set("n", "<leader>fs", save,
    { silent = true, desc = 'File save (format file and save)' })
vim.keymap.set("n", "<C-s>", save, { silent = true, desc = "Save file & format" })
vim.keymap.set("n", "<M-s>", save, { silent = true, desc = "Save file & format" })

vim.keymap.set("n", "Q", "<nop>", { desc = "We don't use Ex mode" })
vim.keymap.set("n", "s", "<nop>", { desc = "Leave my chars alone, i just want to save" })
vim.keymap.set("n", "<leader>", "<nop>", { desc = 'Single leader press does nothing' })

----------------
-- NAVIGATION --
----------------

-- NOTE: netrw is was broken by some update probably, so i'm using 'oil' now
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = 'Project View (show current folder files' })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directior (via oil)" })

-- TODO: this doesn't work as intended, because the buffer order is not consistent
-- with the usage
vim.keymap.set("n", "<C-h>", vim.cmd.bprevious, { desc = 'Goto previous buffer' })
vim.keymap.set("n", "<C-l>", vim.cmd.bnext, { desc = 'Goto next buffer' })

vim.keymap.set("n", "<leader>wd", vim.cmd.close, { noremap = true, desc = 'Window delete - close the window' })
vim.keymap.set("n", "<leader>ww", "<C-w>w", { noremap = true, desc = 'Window window - goto next window' })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { noremap = true, desc = 'window j - window below' })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { noremap = true, desc = 'Window k - window above' })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { noremap = true, desc = 'Window l - window right' })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { noremap = true, desc = 'Window h - window left' })
vim.keymap.set("n", "<leader>w/", vim.cmd.vs, { noremap = true, desc = 'Split window right' })
vim.keymap.set("n", "<leader>w-", vim.cmd.split, { noremap = true, desc = 'Split window below' })

vim.keymap.set({ 'n' }, "<C-k>", "<cmd>cnext<CR>", { desc = 'Quickfix next' })
vim.keymap.set({ 'n' }, "<C-j>", "<cmd>cprev<CR>", { desc = 'Quickfix previous' })
vim.keymap.set('n', "<leader>k", "<cmd>lnext<CR>", { desc = 'Next location within buffer' })
vim.keymap.set('n', "<leader>j", "<cmd>lprev<CR>", { desc = 'Previous location within buffer' })
-- FIXME: this doesn't work
vim.keymap.set({ 'c' }, "<C-k>", "<Down>", { desc = 'Quickfix next', noremap = true })
vim.keymap.set({ 'c' }, "<C-j>", "<Up>", { desc = 'Quickfix previous', noremap = true })
--FIXME: This doesn't work either, maybe they are already defined as noremap?
--vim.keymap.set('c', "<CR>", 'pumvisible() ? "<C-y>" : "<CR>"', { expr = true, noremap = true })

vim.keymap.set("n", "<C-Up>", ":resize -5<CR>", { silent = true, desc = "Move window size up" })
vim.keymap.set("n", "<C-Down>", ":resize +5<CR>", { silent = true, desc = "Move window size down" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -5<CR>", { silent = true, desc = "Move window size left" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +5<CR>", { silent = true, desc = "Move window size right" })



-- TAGS:
-- Remap Ctrl+] to use tjump for better file opening
vim.keymap.set("n", "<C-]>",
    --"<Cmd>tjump <C-R><C-W><CR>",
    function()
        local word = vim.fn.expand('<cword>')
        print("searching word:", word);
        vim.cmd("tjump " .. word)
    end,
    { silent = true })

-- Navigate the tag stack
vim.keymap.set("n", "<C-p>", "<Cmd>pop<CR>", { silent = true })   -- Jump back (pop tag stack)
vim.keymap.set("n", "<C-o>", "<Cmd>pop<CR>", { silent = true })   -- Alternative: use Ctrl+o
vim.keymap.set("n", "<C-n>", "<Cmd>tnext<CR>", { silent = true }) -- Jump forward (next in tag stack)

local function show_msg_in_buffer()
    local msgs = vim.fn.execute("messages")

    vim.cmd("new")

    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(msgs, "\n"))
end

vim.keymap.set("n", "<leader>ms", show_msg_in_buffer, { silent = true })

-----------------------
-- TEXT MANIPULATION --
-----------------------

vim.keymap.set("n", "<leader>ho", vim.cmd.nohlsearch, { desc = 'highlight off - deselect highlight' })
vim.keymap.set("n", "U", "<C-r>");
vim.keymap.set("n", "<leader>mf", refactor.git_move_current,
    { desc = "git [M]ove [f]ile - rename file with git tracking" })

--------------
-- TERMINAL --
--------------

vim.keymap.set('t', '``', '<C-\\><C-n>', { noremap = true, desc = 'Exists terminal insert mode' })
vim.keymap.set({ 'n' }, '`,', '<C-w>wa',
    { noremap = true, desc = 'Jump to next window (terminal) and insert [Win Toggl]' })
vim.keymap.set('n', '<leader>tt', '<C-w>wa<C-\\><C-n><C-w>w',
    { desc = 'Scroll terminal down (insert) and jump back [Win Toggle]' })
vim.keymap.set('t', '`,', '<C-\\><C-n><C-w>w',
    { noremap = true, desc = 'Jump from terminal back to normal window [Win Toggl]' })

-----------------
-- DEVELOPMENT --
-----------------

vim.keymap.set("n", "<leader>xx", function()
    vim.cmd('w')

    local output = vim.fn.execute("silent source %")

    vim.cmd("botright vnew")
    local buf = vim.api.nvim_get_current_buf()

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))
    vim.bo[buf].modifiable = false
end, { desc = 'Saves & runs current file -> puts output into special buffer' })

-- TODO: reload module (for lua dev)
-- TODO: plenary test file (do i need it?)


vim.keymap.set("n", "<leader>i", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

vim.keymap.set("n", "<leader>rl",
    function()
        --vim.cmd('source' .. vim.fn.stdpath('config') .. '/init.lua')
        --vim.notify('Config reload', vim.log.levels.INFO)
        require("plenary.reload").reload_module("config")
        require("plenary.reload").reload_module("mg")
        vim.notify('Config reload', vim.log.levels.INFO)
    end,
    { desc = 'Reload nvim config' })

vim.keymap.set("n", "<space>pt", function() cref.replace_pointer_access(false) end,
    { desc = "(to) pointer: Replace . with -> for word under cursor" })
vim.keymap.set("n", "<space>fp", function() cref.replace_pointer_access(true) end,
    { desc = "from pointer: Replace -> with . for word under cursor" })

vim.keymap.set("n", "<M-t>", tlist.mark_done_under_cursor, { desc = "Todos: done - replaces the '-' with check" })
vim.keymap.set("n", "<M-u>", tlist.update_tasklist, { desc = "Todos: Updates the tasklist counter" })
