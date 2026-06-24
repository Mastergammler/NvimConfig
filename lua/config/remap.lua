local refactor = require('mg.refactoring.refactoringutil')



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
    vim.cmd('so')
end, { desc = 'Saves and runs the current file' })

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


-- [[
-- NOTE: Limited to the first tasklist in the file
-- Will not work with block comments!
-- Will replace any string behind the tasklist
-- TODO:
-- - just append count to the end
-- ✔ auto detect list changes / new item shortcut?
-- ]]
local function update_tasklist()
    local bufnr             = vim.api.nvim_get_current_buf()
    local lines             = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    local commentPrefix     = vim.bo.commentstring:gsub("%%s", "")
    local prefixPat         = vim.pesc(commentPrefix:gsub("%s+$", ""))
    local tasklistPat       = "^%s*" .. prefixPat .. "%s*TASKLIST:"
    local todoPat           = "^%s*" .. prefixPat .. "%s*%-"
    local donePat           = "^%s*" .. prefixPat .. "%s*✔"
    local commentPat        = "^%s*" .. prefixPat

    local tasklistHeaderIdx = nil

    -- Find TASKLIST header
    for i, line in ipairs(lines) do
        if line:match(tasklistPat) then
            tasklistHeaderIdx = i
            break
        end
    end

    if not tasklistHeaderIdx then
        return
    end

    local taskInfo = { total = 0, done = 0 };

    -- search lines after tasklist
    for i = tasklistHeaderIdx + 1, #lines do
        local line = lines[i]

        -- when the comment ends we stop
        if not line:match(commentPat) then
            break
        end

        if line:match(todoPat) then
            taskInfo.total = taskInfo.total + 1
        elseif line:match(donePat) then
            taskInfo.total = taskInfo.total + 1
            taskInfo.done = taskInfo.done + 1
        end
    end

    local newHeader = { string.format(commentPrefix .. " TASKLIST: [%d/%d]", taskInfo.done, taskInfo.total) }
    vim.api.nvim_buf_set_lines(bufnr, tasklistHeaderIdx - 1, tasklistHeaderIdx, true, newHeader)
end

vim.keymap.set("n", "<M-d>", function()
    local current_line = vim.api.nvim_get_current_line()
    local new_line = current_line:gsub(' %- ', ' ✔ ')
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
    update_tasklist()
end, { desc = "Todos: done - replaces the '-' with check" })

vim.keymap.set("n", "<M-t>", update_tasklist, { desc = "Todos: Updates the tasklist counter" })


--  TASKLIST: [7/9]
-- ✔ this is my item
-- ✔ this is done
-- ✔ hello world
-- ✔ this needs to be done
-- ✔ this is done
-- - helllo
-- - hello
--
-- Hello world
-- ✔ hi
-- ✔ okey
