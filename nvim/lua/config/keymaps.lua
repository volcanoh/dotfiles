-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Claude Code keymaps
vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code", silent = true })
vim.keymap.set(
  "n",
  "<leader>cx",
  "<cmd>ClaudeCodeClear<cr>",
  { desc = "Clear Claude Code conversation", silent = true }
)
vim.keymap.set("n", "<leader>cp", "<cmd>ClaudeCodePrompt<cr>", { desc = "Send prompt to Claude Code", silent = true })

-- Additional Claude Code keymaps for visual mode (send selected text)
vim.keymap.set("v", "<leader>cc", ":<C-u>ClaudeCodeSend<cr>", { desc = "Send selection to Claude Code", silent = true })
