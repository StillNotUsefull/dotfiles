return {
	-- Toggleable terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = nil,
			insert_mappings = false,
			terminal_mappings = false,
			persist_size = true,
			persist_mode = true,
			direction = "float",
			start_in_insert = true,
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { desc = desc })
			end

			local function esc_terminal()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
			end

			local Terminal = require("toggleterm.terminal").Terminal

			local float_term = Terminal:new({
				direction = "float",
				hidden = true,
			})

			map({ "n", "t" }, "<c-t>", function()
				if vim.fn.mode() == "t" then
					esc_terminal()
				end
				float_term:toggle()
				vim.cmd("startinsert")
			end, "Toggle floating terminal")
		end,
	},
}
