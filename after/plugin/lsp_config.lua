require("mason").setup();
require("mason-lspconfig").setup();

local on_attach = function(_, bufnr)
    local options = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, options)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, options)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, options)
    vim.keymap.set("n", "<leader>ee", function() vim.diagnostic.open_float() end, options)
    vim.keymap.set("n", "<leader>en", function() vim.diagnostic.goto_next({ severity = 1 }) end, options)
    vim.keymap.set("n", "<leader>ep", function() vim.diagnostic.goto_prev({ severity = 1 }) end, options)
    vim.keymap.set("n", "<leader>.", function() vim.lsp.buf.code_action() end, options)

    -- TODO: this looks more like something for telescope, kind of like grep?
    vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, options)

    -- Rename and save everything, cause buffers don't auto save
    vim.keymap.set("n", "<leader>R", function()
        vim.lsp.buf.rename()
        vim.cmd("wall")
    end, options)
    vim.keymap.set({ "i", "n" }, "<C-k>", function() vim.lsp.buf.signature_help() end, options)

    print "LSP says gogogo"
end

require("lspconfig").lua_ls.setup {
    on_attach = on_attach
}

require("lspconfig").clangd.setup {
    on_attach = on_attach
}
