--[[
  Colorscheme

  This sets the colors for your editor (syntax highlighting, UI, etc.)
--]]

return {
  -- Gruvbox
  --[[
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,  -- Load before other plugins (they might depend on colors)

    config = function()
      require("gruvbox").setup({
        contrast = "hard",  -- hard, soft, or "" (empty for normal)
        -- Higher contrast = darker background, easier to distinguish elements

        -- Optional customizations
        italic = {
          strings = false,   -- Don't italicize strings
          comments = true,   -- Italicize comments (makes them stand out)
          operators = false,
          folds = true,
        },
        bold = true,
        underline = true,
        undercurl = true,
      })

      -- Apply the colorscheme
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  --]]

  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,

    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = false,

        -- Make it higher contrast
        color_overrides = {
          mocha = {
            base = "#000000", -- Pure black background
            mantle = "#000000",
            crust = "#000000",
          },
        },

        integrations = {
          -- Enable integrations with plugins (better colors)
          cmp = true,
          gitsigns = true,
          telescope = true,
          treesitter = true,
          mason = true,
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Tokyonight
  --[[
  {
    "folke/tokyonight.nvim",
    priority = 1000,

    config = function()
      require("tokyonight").setup({
        style = "night",  -- storm, moon, night, day
        -- "night" is the highest contrast variant
      })

      vim.cmd.colorscheme("tokyonight")
    end,
  },
  --]]

  -- Rose Pine
  --[[
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,

    config = function()
      require("rose-pine").setup({
        variant = "main",  -- main, moon, dawn
        dark_variant = "main",
      })

      vim.cmd.colorscheme("rose-pine")
    end,
  },
  --]]
}
