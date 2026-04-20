-- nvim-dap: Debug Adapter Protocol client for Neovim.
-- Provides debugging capabilities (breakpoints, stepping, variable inspection)
-- by integrating with language-specific debug adapters.
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- UI frontend for nvim-dap (scopes, stacks, breakpoints, REPL panes).
    "rcarriga/nvim-dap-ui",
    -- Shows variable values inline as virtual text while debugging.
    "theHamsta/nvim-dap-virtual-text",
    -- Async I/O library required by nvim-dap-ui.
    "nvim-neotest/nvim-nio",
    -- Bridges mason.nvim with nvim-dap so debug adapters can be installed
    -- via Mason and auto-configured for nvim-dap.
    "jay-babu/mason-nvim-dap.nvim",
    -- Enables the telescope-dap extension used below to pick configurations.
    "nvim-telescope/telescope.nvim",
    -- Telescope extension that adds DAP pickers (configurations, breakpoints, etc.).
    "nvim-telescope/telescope-dap.nvim",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Ensure the listed debug adapters are installed via Mason and register
    -- them with nvim-dap automatically.
    require("mason-nvim-dap").setup({
      ensure_installed = { "python", "delve", "js-debug-adapter" },
      automatic_setup = true,
    })

    -- Path where Mason installs the vscode-js-debug adapter.
    local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"

    -- pwa-node adapter: required for Deno (uses Chrome DevTools Protocol).
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          js_debug_path .. "/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    dap.configurations.typescript = {
      {
        name = "Deno - warehouse-wall-v (watch)",
        type = "pwa-node",
        request = "launch",
        cwd = "${workspaceFolder}",
        runtimeExecutable = "deno",
        runtimeArgs = {
          "run",
          "-A",
          "--env-file=supabase/functions/.env",
          "--import-map=supabase/functions/import_map.json",
          "--watch",
          "--inspect",
          "${workspaceFolder}/supabase/functions/warehouse-wall-v/index.ts",
        },
        attachSimplePort = 9229,
        console = "integratedTerminal",
        skipFiles = { "<node_internals>/**" },
        sourceMaps = true,
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
      },
    }

    -- Breakpoint signs (VSCode style)
    vim.fn.sign_define("DapBreakpoint",         { text = "●", texthl = "DapBreakpoint",         linehl = "",              numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition",{ text = "◆", texthl = "DapBreakpointCondition",linehl = "",              numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "●", texthl = "DapBreakpointRejected", linehl = "",              numhl = "" })
    vim.fn.sign_define("DapLogPoint",           { text = "◆", texthl = "DapLogPoint",           linehl = "",              numhl = "" })
    vim.fn.sign_define("DapStopped",            { text = "▶", texthl = "DapStopped",            linehl = "DapStoppedLine",numhl = "" })

    vim.api.nvim_set_hl(0, "DapBreakpoint",         { fg = "#e51400" })
    vim.api.nvim_set_hl(0, "DapBreakpointCondition",{ fg = "#ffa500" })
    vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#888888" })
    vim.api.nvim_set_hl(0, "DapLogPoint",           { fg = "#61afef" })
    vim.api.nvim_set_hl(0, "DapStopped",            { fg = "#ffcc00" })
    vim.api.nvim_set_hl(0, "DapStoppedLine",        { bg = "#2b2b1f" })

    -- Layout igual ao VSCode: sidebar esquerda + console embaixo
    dapui.setup({
      icons = { expanded = "", collapsed = "", current_frame = "" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.40 },
            { id = "watches",     size = 0.20 },
            { id = "stacks",      size = 0.25 },
            { id = "breakpoints", size = 0.15 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl",    size = 0.55 },
            { id = "console", size = 0.45 },
          },
          size = 12,
          position = "bottom",
        },
      },
      controls = {
        enabled = true,
        element = "repl",
        icons = {
          pause      = "",
          play       = "",
          step_into  = "",
          step_over  = "",
          step_out   = "",
          step_back  = "",
          run_last   = "",
          terminate  = "",
          disconnect = "",
        },
      },
      floating = {
        border = "rounded",
        mappings = { close = { "q", "<Esc>" } },
      },
      render = { max_type_length = nil, max_value_lines = 100 },
    })

    -- Inline variable values during debugging
    require("nvim-dap-virtual-text").setup({
      highlight_changed_variables = true,
      show_stop_reason = true,
      virt_text_pos = "eol",
    })

    -- Auto-open dap-ui when a session starts and close it when it ends.
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.continue,          { desc = "DAP Continue" })
    vim.keymap.set("n", "<leader>di", dap.step_into,         { desc = "DAP Step Into" })
    vim.keymap.set("n", "<leader>do", dap.step_over,         { desc = "DAP Step Over" })
    vim.keymap.set("n", "<leader>dO", dap.step_out,          { desc = "DAP Step Out" })
    vim.keymap.set("n", "<leader>dr", dap.restart,           { desc = "DAP Restart" })
    vim.keymap.set("n", "<leader>dx", dap.terminate,         { desc = "DAP Stop" })
    vim.keymap.set("n", "<leader>du", dapui.toggle,          { desc = "DAP Toggle UI" })
    vim.keymap.set("n", "<leader>dl", dap.list_breakpoints,  { desc = "DAP List Breakpoints" })

    vim.keymap.set("n", "<leader>dd", function()
      require("telescope").load_extension("dap")
      require("telescope").extensions.dap.configurations()
    end, { desc = "DAP List Configurations" })
  end,
}
