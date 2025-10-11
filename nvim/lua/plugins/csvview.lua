-- csvview.nvim plugin configuration
-- Reference: https://github.com/hat0uma/csvview.nvim
-- A Neovim plugin for CSV file editing with tabular display

return {
  {
    "hat0uma/csvview.nvim",
    ft = { "csv", "tsv" }, -- Load only for CSV and TSV files
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = {
        --- The number of lines to analyze to determine the delimiter.
        --- If 0, all lines will be analyzed.
        async = true,
        delimiter = {
          default = ",",
          ft = {
            tsv = "\t",
          },
        },
        --- Character used for quotes
        quote_char = '"',
        --- Comments settings
        --- Lines starting with these characters will be treated as comments
        comments = {
          "#",
          "//",
        },
      },
      view = {
        --- Minimum width for columns
        min_column_width = 5,
        --- Spacing between columns
        spacing = 2,
        --- Display header line
        display_header = true,
      },
      keymaps = {
        -- Text objects for selecting fields
        -- 'if' selects inner field (without whitespace)
        -- 'af' selects around field (with whitespace)
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- <Tab> moves to next field, <S-Tab> to previous field
        -- Uncomment below to enable:
        -- next_field = { "<Tab>", mode = { "n", "i" } },
        -- prev_field = { "<S-Tab>", mode = { "n", "i" } },
      },
    },
    config = function(_, opts)
      require("csvview").setup(opts)
    end,
  },
}
