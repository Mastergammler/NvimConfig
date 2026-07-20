-- use ':hi' or ':Telescope highlights' to see the defined colors
-- use :Inspect to see the color groups etc used

vim.keymap.set("n", "<leader>is", function() vim.cmd("Inspect") end,
    { desc = "Inspecting color token types" })

vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#00334d" })


-- COMPILE MODE
vim.api.nvim_set_hl(0, "CompileModeMessage", { link = "Comment" })
vim.api.nvim_set_hl(0, "CompileModeInfo", { link = "@lsp.type.property" })
vim.api.nvim_set_hl(0, "CompileModeWarning", { link = "TodoFgWARN" })
vim.api.nvim_set_hl(0, "CompileModeError", { link = "TodoFgFIX" })
vim.api.nvim_set_hl(0, "CompileModeMessageRow", { link = "CompileModeMessage" })
vim.api.nvim_set_hl(0, "CompileModeMessageCol", { link = "CompileModeMessage" })

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
vim.api.nvim_set_hl(0, "@variable.builtin", {
    link = "@type.qualifier",
    bold = true
})
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
    {
        fg = evenBrighterGreen,
        bg = evenDarkerGreen,
        undercurl = false,
        bold = true
    })

-- setting fold color to comment color for treesitter
vim.cmd("hi! link Folded Comment")


-- **************************************
-- *********    MARKDOWN    *************
-- **************************************

local col_op = vim.api.nvim_get_hl(0, { name = "Operator", link = false })
local col_comm = vim.api.nvim_get_hl(0, { name = "Comment", link = false })
local col_kw = vim.api.nvim_get_hl(0, { name = "Keyword", link = false })
local col_red = vim.api.nvim_get_hl(0, {
    name = "@markup.strong",
    link = false
})
local col_yell = vim.api.nvim_get_hl(0, { name = "NightflyTan", link = false })

--print(vim.inspect(col_kw))
--print(string.format("#%06x", col_kw.fg))

vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", {
    fg = col_op.fg,
    bg = "#680000",
    underline = true
})
vim.api.nvim_set_hl(0, "@markup.heading.2.markdown",
    { fg = col_op.fg, underline = true })
vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { link = "@operator" })
vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { link = "@operator" })
vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { link = "@operator" })
vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { link = "@operator" })
vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline",
    { bg = "#000000", fg = col_comm.fg })
vim.api.nvim_set_hl(0, "@markup.strong.markdown_inline",
    { fg = col_red.fg, bold = true })
vim.api.nvim_set_hl(0, "@markup.link.label", { link = "@function.call" })
vim.api.nvim_set_hl(0, "@markup.italic", { fg = col_yell.fg, italic = true })
vim.api.nvim_set_hl(0, "@markup.raw.block", { bg = "#000000" })
vim.api.nvim_set_hl(0, "@markup.list.markdown",
    { fg = col_kw.fg, bg = "#2b0840" })
vim.api.nvim_set_hl(0, "@markup.list.checked.markdown",
    { bg = darkGreen, fg = brighterGreen })
vim.api.nvim_set_hl(0, "@markup.list.unchecked.markdown",
    { fg = brighterGreen })
