-- https://github.com/agude/vim-eldar

-- local M = {
--   "agude/vim-eldar",
--   commit = "70f681812d2201a44ab53e86df3f98f0d57e2ad0",
--   name = "eldar",
--   lazy = false,    -- make sure we load this during startup
--   priority = 1000, -- make sure to load this before all the other start plugins
-- }

-- https://github.com/catppuccin/nvim

local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000
}

function M.config()
  local opts = {
    flavour = "mocha",
    styles = {
      comments = {},
      conditionals = {},
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
    },
    color_overrides = {
      mocha = {
        base = "#000000",
        mantle = "#000000",
        crust = "#000000",
      },
    },
    custom_highlights = function(colors)
      return {
        VertSplit = { fg = "#fdfd96" },
        StatusLineNC = { fg = "#fdfd96" },
      }
    end
  }

  require("catppuccin").setup(opts)

  local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
  if not status_ok then
    return
  end
end

return M
