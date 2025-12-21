return {
	-- Autoclosing brackets
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	-- Shortcuts for toggleing code comments
	{
		"numToStr/Comment.nvim",
		opts = {},
	},
}
