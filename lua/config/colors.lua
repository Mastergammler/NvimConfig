vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#807b69" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "NightflyRed" })
vim.api.nvim_set_hl(0, "DiganosticVirtualTextInfo", { link = "NightflyBlue" })

-- DIFFVIEW --
vim.api.nvim_set_hl(0, 'DiffAdd', { bg = "#0c2a59" })
--vim.api.nvim_set_hl(0, 'DiffChange', { bg = "#4a4502" })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = "#3b3819" })
vim.api.nvim_set_hl(0, 'DiffText', { bg = "#022799" })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = "#40130a", fg = "#40130a" })
--vim.api.nvim_set_hl(0, 'DiffDelete', { bg = "#40130a", fg = "#d954e" })
