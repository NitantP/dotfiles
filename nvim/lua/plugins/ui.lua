--[[
  UI Enhancements

  Small plugins that improve the Neovim experience:
  - Better status line
  - Indentation guides
  - Color highlighting
  - Auto-pairs (brackets, quotes)
  - Smooth scrolling
--]]

return {
  -- Status line (bottom bar showing mode, file, git, etc.)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    config = function()
      require("lualine").setup({
        options = {
          theme = "auto", -- Matches your colorscheme
          icons_enabled = true,
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } }, -- Show relative path
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Indent guides (vertical lines showing indentation)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },

    config = function()
      require("ibl").setup({
        indent = {
          char = "│", -- Character for indent line
        },
        scope = {
          enabled = false, -- Highlight current scope
          show_start = false,
          show_end = false,
        },
        exclude = {
          filetypes = {
            "help",
            "dashboard",
            "lazy",
            "mason",
            "notify",
          },
        },
      })
    end,
  },

  -- Highlight colors in code (#ff0000, rgb(255,0,0), etc.)
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },

    config = function()
      require("colorizer").setup({
        user_default_options = {
          RGB = true,          -- #RGB hex codes
          RRGGBB = true,       -- #RRGGBB hex codes
          names = false,       -- "Name" codes like Blue
          RRGGBBAA = true,     -- #RRGGBBAA hex codes
          rgb_fn = true,       -- CSS rgb() and rgba() functions
          hsl_fn = true,       -- CSS hsl() and hsla() functions
          mode = "background", -- Display mode (background, foreground, virtualtext)
        },
      })
    end,
  },

  -- Auto-pairs: Automatically close brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",

    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,      -- Use treesitter for smarter pairs
        ts_config = {
          lua = { "string" }, -- Don't add pairs in lua strings
          javascript = { "template_string" },
        },
      })

      -- Integrate with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Smooth scrolling (less jarring)
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",

    config = function()
      require("neoscroll").setup({
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
        hide_cursor = true,
        easing_function = "quadratic", -- quadratic, cubic, quartic, sine
      })
    end,
  },

  -- Which-key: Show keybindings as you type
  {
    "folke/which-key.nvim",
    event = "VeryLazy",

    config = function()
      local wk = require("which-key")

      wk.setup({
        preset = "modern",
        -- Delay before showing which-key popup
        delay = 500,

        -- Window options
        win = {
          border = "rounded",
        },

        -- Show built-in help for operators, motions, text objects
        plugins = {
          presets = {
            operators = true,    -- operators like d, y, c
            motions = true,      -- motions like w, b, e
            text_objects = true, -- text objects like iw, aw
          },
        },
      })

      -- Document leader key groups using new add() API
      wk.add({
        { "<leader>a", group = "AI/Claude" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Diagnostics" },
        { "<leader>f", group = "Find (Telescope)" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Git Hunk" },
        { "<leader>s", group = "Split" },
        { "<leader>w", group = "Workspace" },
      })
    end,
  },

  -- Buffer line (tabs at top)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",

    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",               -- Show buffers (not tabs)
          diagnostics = "nvim_lsp",       -- Show diagnostics in tabs
          separator_style = "slant",      -- slant, padded_slant, slope, padded_slope, thick, thin
          always_show_bufferline = false, -- Hide if only one buffer
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      })
    end,
  },

  -- Highlight todo comments (TODO, FIXME, NOTE, etc.)
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },

    config = function()
      require("todo-comments").setup({
        signs = true, -- Show icons in gutter
        keywords = {
          FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })

      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })

      vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    end,
  },
}

--[[
  UI ENHANCEMENTS:

  STATUS LINE (lualine):
  - Bottom bar showing: mode, git branch, file, errors, position
  - Auto-updates as you edit
  - No configuration needed

  INDENT GUIDES:
  - Vertical lines showing indentation levels
  - Highlights current scope (function/block you're in)
  - Helps with Python, YAML, etc.

  COLOR HIGHLIGHTING:
  - Shows actual colors in code
  - Example: #ff0000 shows red background
  - Works in CSS, HTML, config files

  AUTO-PAIRS:
  - Type ( and get ()
  - Type [ and get []
  - Type " and get ""
  - Cursor lands inside automatically

  WHICH-KEY:
  - Press <leader> and wait 500ms
  - Shows all available keybindings
  - Groups by category (f=find, g=git, etc.)

  BUFFER LINE:
  - Shows open buffers at top (like tabs)
  - Click to switch buffers
  - Shows diagnostics count

  TODO COMMENTS:
  - Highlights TODO, FIXME, HACK, etc. in code
  - Keymaps:
    ]t - Next todo
    [t - Previous todo
    <leader>ft - Find all todos

  Example:
  // TODO: This will be highlighted
  // FIXME: This too, in red
  // NOTE: This in blue

  CUSTOMIZATION:

  Disable any plugin:
  - Comment out or delete the block

  Change status line:
  - Edit lualine sections in config

  Change indent guides:
  - Edit char = "│" to change line character

  TIPS:

  - All these plugins are optional
  - They don't affect core functionality
  - Remove any you don't want
  - Most are "set and forget"
--]]
