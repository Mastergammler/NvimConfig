return {
    {
        "bluz71/vim-nightfly-colors",
        as = 'nightfly',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme nightfly]])
        end,
    },
    {
        "theprimeagen/harpoon",
        lazy = false
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup {
                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol',
                    delay = 1000,
                    ignore_whitespace = false
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>'
            }
        end
    },
    {
        "sindrets/diffview.nvim",
        config = function()
            require("diffview").setup {
                -- TODO: make it a toggle trigger?
                -- -> For that i would need to know if it's currently open or not
                vim.keymap.set("n", "<leader>sd", vim.cmd.DiffviewOpen, { desc = "Show diff - current changes" }),
                vim.keymap.set("n", "<leader>cd", function()
                    vim.cmd.DiffviewClose()
                    vim.cmd("windo diffoff")
                end, { desc = "Close diff view / diffoff" }),
                vim.keymap.set("n", "<leader>dd", function() vim.cmd("windo diffthis") end, { desc = "diff dis - Diff current open buffers" })
            }
        end
    },
    {
        'nvim-treesitter/nvim-treesitter'
    }
}
