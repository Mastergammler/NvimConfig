local dap = require("dap")
local dapui = require("dapui")
local proj = require("mg.projectutil")

require("dapui").setup()
require("nvim-dap-virtual-text").setup()

--dap.set_log_level("DEBUG")

vim.keymap.set("n", "<F1>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<F9>", dap.step_into, { desc = "step into" })
vim.keymap.set("n", "<F8>", dap.step_out, { desc = "step out of" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "step (over)" })
vim.keymap.set("n", "<F4>", dap.terminate, { desc = "Terminate" })
vim.keymap.set("n", "<C-w>", function() dapui.elements.watches.add(vim.fn.expand('<cword>')) end,
    { desc = "Add to watch" })
vim.keymap.set("n", "<C-v>", function() require("dapui").eval(nil, { enter = true }) end,
    { desc = "Evaluate current value" })

dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

dap.adapters.gdb = {
    type = 'executable',
    command = 'gdb',
    args = { '-i', 'dap' }
}

dap.configurations.c = {
    {
        name = 'Launch GDB',
        type = 'gdb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtBeginningOfMainSubprogram = false,
        console = 'integratedTerminal'
    }
}
dap.configurations.cpp = dap.configurations.c

require('dap-cs').setup(
    {
        dap_configurations = {
            {
                type = "coreclr",
                name = "Attach remote",
                mode = "remote",
                request = "attach"
            }
        },
        netcoredb = {
            path = vim.fn.stdpath("data") .. '/mason/packages/netcoredbg/netcoredbg'
        }
    }
)
--[[dap.adapters.coreclr = {
    type = 'executable',
    command = vim.fn.stdpath("data") .. '/mason/packages/netcoredbg/netcoredbg',
    args = { '--interpreter=vscode' }
}

local function findProjectFilePath()
    local projectFile = proj.find_project_file({ GlobPattern = "*.csproj" });
    print(projectFile)
end

dap.configuration.cs = {
    {
        type = "coreclr",
        name = "Launch - netcoredbg",
        request = "launch",
        program = function()
            -- TODO: hardcoded bin path
            return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/net8.0', 'file')
        end,
        -- TODO: i probably need to find the correct project folder here? -> project root
        cwd = "${workspaceFolder}",
        stopAtEntry = false,
    }
}]]


print("a-dap-ters loaded")

vim.keymap.set("n", "<leader>gc", function()
    vim.cmd("w")
    vim.cmd("so")
    --findProjectFilePath();
end, { desc = "go command!!!! - runs a test function somewhere" });
