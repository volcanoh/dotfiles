-- Marksman LSP for Markdown
-- https://github.com/artempyanykh/marksman
return {
  -- Configure LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          -- Marksman specific configuration
          filetypes = { "markdown", "markdown.mdx" },
          single_file_support = true,
          settings = {
            -- You can add marksman-specific settings here if needed
          },
        },
      },
    },
  },

  -- Ensure marksman is installed via mason
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "marksman",
      },
    },
  },

  -- Configure treesitter for markdown (if not already configured)
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
      end
    end,
  },
}
