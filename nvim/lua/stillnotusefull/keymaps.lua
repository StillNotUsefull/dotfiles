-- ═══════════════════════════════════════════════════════════════
-- Keymaps
-- ═══════════════════════════════════════════════════════════════

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Open file explorer
vim.keymap.set("n", "<leader>pg", vim.cmd.Ex)

-- Better v paster
vim.keymap.set("v", "p", '"_dP')

-- better indenting in v
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<leader>cs", function()
	local ft = vim.bo.filetype
	local title = vim.api.nvim_get_current_line():match("^%s*(.-)%s*$")

	-- Comment styles per filetype
	local styles = {
		lua = { prefix = "-- ", inline = nil },
		python = { prefix = "# ", inline = nil },
		sh = { prefix = "# ", inline = nil },
		bash = { prefix = "# ", inline = nil },
		zsh = { prefix = "# ", inline = nil },
		sql = { prefix = "-- ", inline = nil },
		javascript = { prefix = nil, inline = { "/* ", " */" } },
		typescript = { prefix = nil, inline = { "/* ", " */" } },
		javascriptreact = { prefix = nil, inline = { "/* ", " */" } },
		typescriptreact = { prefix = nil, inline = { "/* ", " */" } },
		c = { prefix = nil, inline = { "/* ", " */" } },
		cpp = { prefix = "// ", inline = nil },
		rust = { prefix = "// ", inline = nil },
		go = { prefix = "// ", inline = nil },
	}

	local style = styles[ft]
	if not style then
		vim.notify("No section comment style for filetype: " .. ft, vim.log.levels.WARN)
		return
	end

	local width = 63
	local bar = string.rep("═", width)
	local section

	if style.prefix then
		local p = style.prefix
		section = string.format("%s%s\n%s%s\n%s%s", p, bar, p, title, p, bar)
	else
		local open, close = style.inline[1], style.inline[2]
		section = string.format("%s%s%s\n%s %s %s\n%s%s%s", open, bar, close, open, title, close, open, bar, close)
	end

	local row = vim.api.nvim_win_get_cursor(0)[1] - 1
	vim.api.nvim_buf_set_lines(0, row, row + 1, false, vim.split(section, "\n"))
end, { desc = "Create section comment from current line" })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Keybinds to make split navigation easier.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
