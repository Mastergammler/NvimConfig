require("mason").setup();
require("mason-lspconfig").setup();
util = require("mg.projectutil")

local on_attach = function(_, bufnr)
    local options = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, options)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, options)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, options)
    vim.keymap.set("n", "<leader>ee", function() vim.diagnostic.open_float() end, options)
    vim.keymap.set("n", "<leader>en", function() vim.diagnostic.goto_next({ severity = 1 }) end, options)
    vim.keymap.set("n", "<leader>ep", function() vim.diagnostic.goto_prev({ severity = 1 }) end, options)
    vim.keymap.set("n", "<leader>.", function() vim.lsp.buf.code_action() end, options)

    -- Rename and save everything, cause buffers don't auto save
    vim.keymap.set("n", "<leader>R", function()
        vim.lsp.buf.rename()
        vim.cmd("wall")
    end, options)
    vim.keymap.set({ "i", "n" }, "<C-k>", function() vim.lsp.buf.signature_help() end, options)

    print "LSP says gogogo"
end

------------------
-- AUTOCOMPLETE --
------------------

local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            -- NOTE: NVIM v0.10+
            vim.snippet.expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        --TODO: what does scroll docs do?
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-k>'] = cmp.mapping.select_prev_item({ behaviour = cmp.SelectBehavior.Select }),
        ['<C-j>'] = cmp.mapping.select_next_item({ behaviour = cmp.SelectBehavior.Select }),
        -- this opens the auto complete line, but i usually don't use this
        -- . doesn't really work for this
        --['<C-.>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },
        ['<C-Space>'] = cmp.mapping(function(fallback)
            -- TODO: what is this? same as completion list?
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.snippet.active({ direction = 1 }) then
                vim.snippet.jump(1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    -- use preselect and completeopts together that it works correctly
    preselect = cmp.PreselectMode.Item,
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer' }
    })
})

-- completion for git branches etc???
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' }
    })
})
-- provides completion for search etc
-- TODO: do i need this?
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- TODO: what exactly does this do?
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})


----------
-- LSPS --
----------

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("lspconfig").lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

require("lspconfig").clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

if util.is_windows() then
    -- FIXME: for some reason it is not installable on ubuntu
    -- but omnisharp worked fine without a problem
    -- maybe it has something to do with F#, which has to be installed extra?
    require("lspconfig").csharp_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
else
    require("lspconfig").omnisharp.setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
end

require("lspconfig").jsonls.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

require("lspconfig").eslint.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

require("lspconfig").tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities
}
