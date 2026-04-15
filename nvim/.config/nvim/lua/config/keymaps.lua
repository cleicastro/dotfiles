vim.g.mapleader = " "
local map = vim.keymap.set

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")

-- LSP
map("n", "gd", vim.lsp.buf.definition)
map("n", "K", vim.lsp.buf.hover)

-- Save
map("n", "<leader>w", "<cmd>w<CR>")

-- Neo-tree
map("n", "<leader>e", "<cmd>Neotree toggle<CR>")

-- Lazygit
map("n", "<leader>gg", function() Snacks.lazygit() end,           { desc = "Lazygit" })
map("n", "<leader>gl", function() Snacks.lazygit.log() end,       { desc = "Lazygit log" })
map("n", "<leader>gf", function() Snacks.lazygit.log_file() end,  { desc = "Lazygit log (file)" })
