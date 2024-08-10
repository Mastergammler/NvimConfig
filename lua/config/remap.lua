vim.keymap.set("n","<leader>fs", function()
    vim.lsp.buf.format()
    vim.cmd.update()
end , {silent = true, desc = 'File save (format file and save)'})

vim.keymap.set("n","Q","<nop>", {desc = "We don't use Ex mode"})
vim.keymap.set("n","<leader>","<nop>",{desc = 'Single leader press does nothing'})

----------------
-- NAVIGATION --
----------------

vim.keymap.set("n","<leader>pv",vim.cmd.Ex, {desc = 'Project View (show current folder files'})

-- TODO: this doesn't work as intended, because the buffer order is not consistent
-- with the usage
vim.keymap.set("n","<C-h>",vim.cmd.bprevious, {desc = 'Goto previous buffer'})
vim.keymap.set("n","<C-l>",vim.cmd.bnext, {desc = 'Goto next buffer'})

vim.keymap.set("n","<leader>wd",vim.cmd.close, {noremap = true, desc = 'Window delete - close the window'})
vim.keymap.set("n","<leader>ww","<C-w>w", {noremap = true, desc = 'Window window - goto next window'})
vim.keymap.set("n","<leader>wj","<C-w>j", {noremap = true, desc = 'window j - window below'})
vim.keymap.set("n","<leader>wk","<C-w>k", {noremap = true, desc = 'Window k - window above'})
vim.keymap.set("n","<leader>wl","<C-w>l", {noremap = true, desc = 'Window l - window right'})
vim.keymap.set("n","<leader>wh","<C-w>h", {noremap = true, desc = 'Window h - window left'})
vim.keymap.set("n","<leader>w/",vim.cmd.vs, {noremap = true, desc = 'Split window right'})
vim.keymap.set("n","<leader>w-",vim.cmd.split, {noremap = true, desc = 'Split window below'})

vim.keymap.set('n',"<C-k>","<cmd>cnext<CR>", {desc = 'Quickfix next'})
vim.keymap.set('n',"<C-j>","<cmd>cprev<CR>", {desc = 'Quickfix previous'})
vim.keymap.set('n',"<leader>k","<cmd>lnext<CR>", {desc = 'Next location within buffer'})
vim.keymap.set('n',"<leader>j","<cmd>lprev<CR>", {desc = 'Previous location within buffer'})

-----------------------
-- TEXT MANIPULATION --
-----------------------

vim.keymap.set("n","<leader>ho",vim.cmd.nohlsearch, {desc = 'highlight off - deselect highlight'})

--------------
-- TERMINAL --
--------------

vim.keymap.set('t','``','<C-\\><C-n>', {noremap = true, desc = 'Exists terminal insert mode'})
vim.keymap.set({'n'}, '`,','<C-w>wa',{noremap = true, desc = 'Jump to next window (terminal) and inserct [Dual window]' })
-- TODO: does this work with using the remapped command?
vim.keymap.set('t', '`,','``<C-w>w',{noremap = true, desc = 'Jump from terminal back to normal window [Dual window]' })

-----------------
-- DEVELOPMENT --
-----------------

vim.keymap.set("n","<leader>xx", function()
    vim.cmd('w')
    vim.cmd('so')
end, {desc = 'Saves and runs the current file'})

-- TODO: reload module (for lua dev)
-- TODO: plenary test file (do i need it?)
