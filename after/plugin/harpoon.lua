local mark = require('harpoon.mark')
local ui = require("harpoon.ui")
local term = require("harpoon.term")
local projcmd = require("mg.projectcmd")

vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Add - file to harpoon list" })
vim.keymap.set("n", "<leader>lh", ui.toggle_quick_menu, { desc = "list harpoon - page" })
vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)
vim.keymap.set({ "n", "t" }, "`1", function() term.gotoTerminal(1) end)
vim.keymap.set({ "n", "t" }, "`2", function() term.gotoTerminal(2) end)
vim.keymap.set({ "n", "t" }, "`3", function() term.gotoTerminal(3) end)
vim.keymap.set({ "n", "t" }, "`4", function() term.gotoTerminal(4) end)
vim.keymap.set({ "n", "t" }, "`5", function() term.gotoTerminal(5) end)


------------------------
-- SEND TERM COMMANDS --
------------------------

function cmd(cmdNo, commandName, cmdappend)
    local cmd = projcmd.get_project_cmd(commandName, cmdappend);
    if cmd == nil then
        print "Project type could not be determined! Aborting execution"
        return
    end

    term.sendCommand(cmdNo, cmd .. "\r")
    print("Executing", commandName, "command ...")
end

vim.keymap.set("n", "<C-B>", function() cmd(1, "build") end, { desc = "Build project" })
vim.keymap.set("n", "<C-R>", function() cmd(1, "run") end, { desc = "Run project" })
vim.keymap.set("n", "<C-T>", function() cmd(2, "test") end, { desc = "Test project" })
vim.keymap.set("n", "<leader>tf", function()
    local fileName = vim.fn.fnamemodify(vim.fn.bufname(), ":t:r")
    local cmdappend = "--filter " .. fileName
    cmd(2, "test", cmdappend)
    print("Start Testing file", fileName, "...")
end, { desc = "Test file - runs dotnet test for current file" })
