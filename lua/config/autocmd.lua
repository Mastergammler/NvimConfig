local blazor = require("mg.test.blazor")

local highlightGroup = vim.api.nvim_create_augroup("CustomHighlight", { clear = false })

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedP", "TextChangedI" }, {
    pattern = "*.blazor",
    group = highlightGroup,
    callback = function()
        vim.defer_fn(function()
            blazor.highlight()
        end, 100)
    end
})
