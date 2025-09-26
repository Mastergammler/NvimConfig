local dap = require("dap")
local proj = require("mg.projectutil")

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


vim.keymap.set("n", "<leader>gc", function()
    vim.cmd("w")
    vim.cmd("so")
    --findProjectFilePath();
end, { desc = "go command!!!! - runs a test function somewhere" });
