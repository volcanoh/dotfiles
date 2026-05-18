-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Force clipboard yanks over SSH/tmux to use OSC 52.
vim.g.clipboard = "osc52"
vim.opt.clipboard = "unnamedplus"
