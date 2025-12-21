-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Open file explorer
vim.keymap.set("n", "<leader>pg", vim.cmd.Ex)

-- Allow lines to be shifted up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Enhances joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- Keeps cursor centered on scroll
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Enhances search navigation
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Reformat a Paragraph
vim.keymap.set("n", "=ap", "ma=ap'a")

-- Restart LSP
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- Paste over select
vim.keymap.set("x", "<leader>P", [["_dP]])

-- Delets without having affect to registers
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- Search and replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
