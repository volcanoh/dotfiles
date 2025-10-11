-- claudecode.nvim plugin configuration
-- Reference: https://github.com/coder/claudecode.nvim
-- Using claude-code-router (ccr): https://github.com/musistudio/claude-code-router
--
local toggle_key = "<C-,>"

return {
  {
    "coder/claudecode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    opts = {
      terminal_cmd = "/opt/homebrew/bin/ccr code", -- Point to local installation
    },
    terminal = {
      ---@module "snacks"
      ---@type snacks.win.Config|{}
      snacks_win_opts = {
        position = "float",
        width = 0.6,
        height = 0.6,
        border = "double",
        backdrop = 80,
        keys = {
          claude_hide = {
            "<Esc>",
            function(self)
              self:hide()
            end,
            mode = "t",
            desc = "Hide",
          },
          claude_close = { "q", "close", mode = "n", desc = "Close" },
        },
      },
      -- snacks_win_opts = {
      --   position = "float",
      --   width = 0.9,
      --   height = 0.9,
      --   keys = {
      --     claude_hide = {
      --       toggle_key,
      --       function(self)
      --         self:hide()
      --       end,
      --       mode = "t",
      --       desc = "Hide",
      --     },
      --   },
      -- },
    },

    -- Load on these events
    event = "VeryLazy",

    keys = {
      { toggle_key, "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code", mode = { "n", "x" } },
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
