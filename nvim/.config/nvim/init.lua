-- =========================
-- Bootstrap lazy.nvim: Bootstraps lazy.nvim plugin manager if not installed
-- =========================
---@diagnostic disable: undefined-global vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Set leader key to space (must be before plugins load)
vim.g.mapleader = " "

-- =========================
-- Plugins: Load and configure plugins from plugins/ directory
-- =========================
require("lazy").setup("plugins")

-- =========================
-- Config: Load user configuration and keybindings
-- =========================
require("config.options")
require("config.keymaps")
