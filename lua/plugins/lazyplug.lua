return {
    {
        "mbbill/undotree",
        lazy = false
    },
    {
        "folke/todo-comments.nvim",
        lazy = false,
        opts = { signs = false }
    },
    {
        'nvim-telescope/telescope.nvim',
        lazy = false,
        priority = 800,
    },
    {
        'nvim-lua/plenary.nvim',
        lazy = true
    },
    {
        'stevearc/oil.nvim',
        lazy = true
    },
    {
        'NicholasMata/nvim-dap-cs',
        lazy = true
    },
    {
        "mfussnegger/nvim-dap",
        lacy = true,
        config = function()
            print("dap init")
            -- Keymap examples
            vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end,
                { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue" })
            vim.keymap.set("n", "<leader>dT", function() require("dap").terminate() end, { desc = "Terminate" })
        end
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
        lazy = true,
        config = function()
            require("dapui").setup()
            -- Optionally auto-open/close ui when debug events fire
            local dap = require("dap")
            local dapui = require("dapui")
            dap.listeners.before.attach.dapui_config = function() dapui.open() end
            dap.listeners.before.launch.dapui_config = function() dapui.open() end
            dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
            dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
        end
    }
}
