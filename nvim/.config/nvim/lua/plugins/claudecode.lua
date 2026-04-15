return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },

  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeRestart",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
  },

  keys = {
    { "<leader>a",  nil,                            desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>",          desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",     desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",     desc = "Add buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>",      mode = "v", desc = "Send to Claude" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",  desc = "Deny diff" },
  },

  opts = {
    terminal_cmd = "claude",
    terminal = {
      split_side = "right",
      split_width_percentage = 0.38,
    },
    context = {
      auto_add_files = true,
    },
  },

  config = function(_, opts)
    require("claudecode").setup(opts)
  end,
}
