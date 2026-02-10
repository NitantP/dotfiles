--[[
  Telescope - Fuzzy Finder

  Replaces: fzf, ag, rg file searching
  What it does: Fuzzy find ANYTHING (files, text, buffers, help, keymaps, etc.)

  Why Telescope over fzf:
  - Pure Lua (no external dependencies)
  - Can search anything (extensible)
  - Better Neovim integration
  - Nice UI with previews

  Most used keymaps:
  - <leader>ff = Find files
  - <leader>fg = Find in files (grep)
  - <leader>fb = Find buffers
--]]

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",

    -- Load only when using telescope commands
    cmd = "Telescope",

    -- Required dependencies
    dependencies = {
      "nvim-lua/plenary.nvim",  -- Lua utility library

      -- Better sorting algorithm (optional but recommended)
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",  -- Compiles the C code for speed
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },

      "nvim-tree/nvim-web-devicons",  -- File icons
    },

    -- Keymaps (loaded before plugin)
    keys = {
      -- Files
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Find recent files" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Find recent files (alias)" },

      -- Search
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find in files (grep)" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find word under cursor" },

      -- Buffers & Help
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Find keymaps" },

      -- Git (if you use it)
      { "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "Find git commits" },
      { "<leader>fs", "<cmd>Telescope git_status<cr>", desc = "Find git status" },

      -- Neovim internals
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Find diagnostics" },
      { "<leader>ft", "<cmd>Telescope treesitter<cr>", desc = "Find treesitter symbols" },
    },

    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          -- Appearance
          prompt_prefix = " ",   -- Icon before prompt
          selection_caret = " ", -- Icon for selected item
          path_display = { "smart" }, -- Shorten paths intelligently

          -- Behavior
          sorting_strategy = "ascending", -- Results appear top to bottom
          layout_config = {
            horizontal = {
              prompt_position = "top",  -- Search bar at top (more natural)
              preview_width = 0.55,     -- Preview takes 55% of width
            },
            width = 0.87,
            height = 0.80,
          },

          -- Keymaps inside telescope
          mappings = {
            i = {  -- Insert mode
              ["<C-j>"] = actions.move_selection_next,     -- Ctrl-j to move down
              ["<C-k>"] = actions.move_selection_previous, -- Ctrl-k to move up
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,  -- Send to quickfix
              ["<Esc>"] = actions.close,  -- Escape to close (not just Ctrl-C)
            },
            n = {  -- Normal mode
              ["q"] = actions.close,  -- q to quit
            },
          },

          -- File/folder ignore patterns
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "dist/",
            "build/",
            "target/",  -- Rust build directory
            "%.lock",   -- Lock files
          },
        },

        -- Specific picker configurations
        pickers = {
          find_files = {
            hidden = true,  -- Show hidden files (dotfiles)
            -- Uncomment to show files ignored by .gitignore:
            -- find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },

          live_grep = {
            additional_args = function()
              return { "--hidden" }  -- Search in hidden files
            end,
          },

          buffers = {
            sort_lastused = true,  -- Most recently used buffers first
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,  -- Ctrl-d to delete buffer
              },
            },
          },
        },

        extensions = {
          -- FZF extension for better sorting
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- Load extensions
      -- FZF native for faster sorting (if installed)
      pcall(telescope.load_extension, "fzf")
    end,
  },
}

--[[
  TELESCOPE USAGE:

  FINDING FILES:
  1. Press <leader>ff
  2. Type part of filename (fuzzy matching)
  3. Use Ctrl-j/k to navigate
  4. Press Enter to open

  SEARCHING IN FILES (like grep):
  1. Press <leader>fg
  2. Type search term
  3. See live results as you type
  4. Navigate and open file

  INSIDE TELESCOPE:
  - Ctrl-j/k: Navigate up/down
  - Enter: Open file
  - Ctrl-x: Open in horizontal split
  - Ctrl-v: Open in vertical split
  - Ctrl-t: Open in new tab
  - Ctrl-q: Send all results to quickfix list
  - Esc: Close telescope

  TIPS:
  - Use ' to match exact characters (no fuzzy)
  - Use ^ to match start of line
  - Use $ to match end of line
  - Use ! to negate (exclude)

  Example: '!test  = find files NOT containing "test"

  ALTERNATIVES TO FZF COMMAND LINE:

  Instead of:                      Use:
  fzf                              <leader>ff
  find . -name "*.rs"              <leader>ff then type .rs
  rg "pattern"                     <leader>fg then type pattern
  grep -r "pattern" .              <leader>fg then type pattern

  CUSTOMIZATION:

  To add more keymaps, add to the `keys` table above:
  { "<leader>f?", "<cmd>Telescope ?<cr>", desc = "Description" },

  See all pickers: :Telescope (then Tab for completion)
--]]
