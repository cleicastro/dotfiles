return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then return end

    configs.setup({
      ensure_installed = { "lua", "javascript", "typescript", "tsx", "html", "css" },
      highlight = { enable = true },
    })
  end,
}
