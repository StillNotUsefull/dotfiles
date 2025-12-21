return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("noice").setup({
				messages = {
					enabled = false,
				},
				popupmenu = {
					enabled = false,
				},
				notify = {
					enabled = false,
				},

				lsp = {
					progress = {
						enabled = false,
					},
					hover = {
						enabled = false,
					},
					signature = {
						enabled = false,
					},
					message = {
						enabled = false,
					},
				},

				cmdline = {
					enabled = true,
					view = "cmdline_popup",
					format = {
						cmdline = { pattern = "^:", icon = ":", lang = "vim" },
						search_down = { pattern = "^/", icon = "/", lang = "regex" },
						search_up = { pattern = "^%?", icon = "?", lang = "regex" },
					},
				},

				routes = {},
			})
		end,
	},
}
