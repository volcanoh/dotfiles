-- render-markdown.nvim - Rich markdown rendering in Neovim
-- https://github.com/MeanderingProgrammer/render-markdown.nvim
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- Required for parsing
      "nvim-tree/nvim-web-devicons", -- Optional: for icons
    },
    ft = { "markdown" }, -- Load only for markdown files
    opts = {
      -- Render styles
      heading = {
        -- Add icons and colors to headings
        enabled = true,
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        -- Render code blocks with background
        enabled = true,
        sign = true,
        style = "full", -- 'full', 'normal', 'language', 'none'
        left_pad = 2,
        right_pad = 2,
      },
      bullet = {
        -- Render list bullets nicely
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        -- Render checkboxes
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰱒 " },
      },
      quote = {
        -- Render blockquotes
        enabled = true,
        icon = "▋",
      },
      link = {
        -- Render links
        enabled = true,
        image = "󰥶 ",
        hyperlink = "󰌹 ",
      },
    },
    keys = {
      {
        "<leader>um",
        "<cmd>RenderMarkdown toggle<cr>",
        desc = "Toggle Markdown Rendering",
        ft = "markdown",
      },
    },
  },
}
