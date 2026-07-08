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
        'nvim-lualine/lualine.nvim',
        lazy = true,
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        'Glench/vim-jinja2-syntax',
        lazy = true
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
        },
        lazy = true,
        config = function()
        end
    },
    {
        "ej-shafran/compile-mode.nvim",
        version = "^5.0.0",
        -- you can just use the latest version:
        -- branch = "latest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- if you want to enable coloring of ANSI escape codes in
            -- compilation output, add:
            { "m00qek/baleia.nvim", tag = "v1.3.0" },
        },
        config = function()
            ---@type CompileModeOpts
            vim.g.compile_mode = {
                -- if you use something like `nvim-cmp` or `blink.cmp` for completion,
                -- set this to fix tab completion in command mode:
                input_word_completion = true,
                buffer_name = "*compilation*",
                -- to add ANSI escape code support, add:
                baleia_setup = true,

                -- to make `:Compile` replace special characters (e.g. `%`) in
                -- the command (and behave more like `:!`), add:
                bang_expansion = true,

                use_circular_error_navigation = true
            }
        end
    },
    {
        "m4xshen/hardtime.nvim",
        lazy = false,
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            restricted_keys = {
                ["k"] = false,
                ["j"] = false,
            }

        }
    },
    {
        "stevearc/dressing.nvim",
        opts = {}
    }
}
