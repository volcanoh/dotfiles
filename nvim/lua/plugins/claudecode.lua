-- claudecode.nvim plugin configuration
-- Reference: https://github.com/coder/claudecode.nvim
-- Using claude-code-router (ccr): https://github.com/musistudio/claude-code-router

return {
  {
    "coder/claudecode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      terminal_cmd = "/opt/homebrew/bin/ccr code", -- Point to local installation
    },

    -- Load on these events
    event = "VeryLazy",
  },
}
