return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- TypeScript / JavaScript
    vim.lsp.config("ts_ls", { capabilities = capabilities })
    vim.lsp.enable("ts_ls")

    -- Lua
    vim.lsp.config("lua_ls", { capabilities = capabilities })
    vim.lsp.enable("lua_ls")

    -- Go
    vim.lsp.config("gopls", { capabilities = capabilities })
    vim.lsp.enable("gopls")
  end,
}
