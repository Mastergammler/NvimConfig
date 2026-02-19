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
        "mfussnegger/nvim-dap",
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
}
