-- use ':hi' or ':Telescope highlights' to see the defined colors
--

--vim.api.nvim_set_hl(0, "Normal", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", ctermbg = "none" })
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

-- TREESITTER --
vim.api.nvim_set_hl(0, "@variable", { fg = "#cccccc" })
vim.api.nvim_set_hl(0, "@string", { fg = "#afd676", italic = false })
vim.api.nvim_set_hl(0, "@storageclass", { link = "@type.qualifier" })
vim.api.nvim_set_hl(0, "@constant.builtin", { link = "@type.qualifier" })
vim.api.nvim_set_hl(0, "@variable.builtin", { link = "@type.qualifier", bold = true })
vim.api.nvim_set_hl(0, "@type.builtin", { link = "@type.qualifier" })
vim.api.nvim_set_hl(0, "@constructor", { link = "@conditional" })
vim.api.nvim_set_hl(0, "@include", { link = "@type.qualifier" })
vim.api.nvim_set_hl(0, "@type", { fg = "#e6d179" })
--vim.api.nvim_set_hl(0, "@type", { fg = "#d9c578" })
vim.api.nvim_set_hl(0, "@boolean", { link = "@number" })
vim.api.nvim_set_hl(0, "@conditional", { fg = "#7dddff" })
vim.api.nvim_set_hl(0, "@repeat", { link = "@conditional" })
vim.api.nvim_set_hl(0, "@exception", { link = "@conditional" })

-- DAP --
vim.api.nvim_set_hl(0, "DapBreakpointLine", { bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapBreakpointColor", { link = "@operator" })
vim.api.nvim_set_hl(0, "DapStopColor", { link = "@conditional" })
vim.fn.sign_define('DapBreakpoint', {
    text = '⏺',
    texthl = 'DapBreakpointColor',
    linehl = 'DapBreakpointLine',
    numhl = 'DapBreakpointColor'
})
vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#990099', bold = true, fg = '#ffe6ff' })
vim.fn.sign_define('DapStopped', {
    text = '⏩',
    texthl = 'DapStopColor',
    linehl = 'DapStoppedLine',
    numhl = 'DopStopColor'
})

-- LSP --

evenDarkerGreen = "#033c3b"
darkerGreen = "#074948"
darkGreen = "#0e5e5c"
darkishGreen = "#12746c"
brighterGreen = "#1cad95"
evenBrighterGreen = "#28c1a8"

-- CPP --
vim.api.nvim_set_hl(0, "@lsp.type.type.cpp", { link = "@lsp.type.builtinType" })
-- FIXME: seems like undercurl is not working
vim.api.nvim_set_hl(0, "@lsp.type.macro",
    { fg = evenBrighterGreen, bg = evenDarkerGreen, undercurl = false, bold = true })

-- setting fold color to comment color for treesitter
vim.cmd("hi! link Folded Comment")
