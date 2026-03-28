local COMPILE_WIN_NAME = "*compilation*"

vim.keymap.set("n", "<leader>cc", function()
    local winid = vim.fn.bufwinid(COMPILE_WIN_NAME)

    if winid ~= -1 then
        -- just refresh the window
        vim.cmd("Recompile")
    else
        vim.cmd("Recompile")
        -- match buffer name in config!
        vim.cmd("buffer " .. COMPILE_WIN_NAME)
        vim.cmd("wincmd L")
    end

    -- FIXME: This doesn't work, because the plugin is not fast enough that it can be called immediately
    vim.cmd("NextError")
end, { desc = "Run via compile mode", noremap = true })

vim.keymap.set("n", "<leader>nn", function() vim.cmd("NextError") end, { desc = "Jump to next compile error" })
