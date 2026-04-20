return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.lsp.config("ts_ls", {
      capabilities = capabilities,
      on_new_config = function(config, root_dir)
        local tsserver_path = root_dir .. "/node_modules/typescript/lib/tsserver.js"
        if vim.loop.fs_stat(tsserver_path) then
          config.cmd = {
            "typescript-language-server",
            "--stdio",
            "--tsserver-path",
            tsserver_path,
          }
        end
      end,
    })
    vim.lsp.enable("ts_ls")

    vim.lsp.config("lua_ls", { capabilities = capabilities })
    vim.lsp.enable("lua_ls")

    vim.lsp.config("gopls", { capabilities = capabilities })
    vim.lsp.enable("gopls")
  end,
}
