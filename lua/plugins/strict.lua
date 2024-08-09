return {
	{
		"bluz71/vim-nightfly-colors",
		as = 'nightfly',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme nightfly]])
		end,
	}}
