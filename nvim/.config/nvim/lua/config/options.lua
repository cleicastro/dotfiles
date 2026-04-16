vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoread = true

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.expandtab = true

-- Visual
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.statusline = "%#TabLineSel#%{trim(system('git rev-parse --abbrev-ref HEAD 2>/dev/null'))}%* %t %= %l/%c %p%% "
