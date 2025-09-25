local blazor = require("mg.test.blazor")

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged","TextChangedP","TextChangedI" }, {
    pattern = "*.blazor",
    callback = function()
        vim.defer_fn(function()
            blazor.highlight()
        end, 100)
    end
})
