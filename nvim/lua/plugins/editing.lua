--[[
  Editing Enhancements

  Plugins that make editing code easier:
  - Comment toggling
  - Surround (quotes, brackets, tags)
  - Multiple cursors
  - Better increment/decrement
--]]

return {
  -- Comment toggling (gcc to comment line)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },

    config = function()
      require("Comment").setup({
        -- Keymaps
        toggler = {
          line = "gcc",   -- Toggle current line
          block = "gbc",  -- Toggle block comment
        },
        opleader = {
          line = "gc",   -- Line comment operator
          block = "gb",  -- Block comment operator
        },

        -- Extra keymaps (Ctrl-/ to toggle in insert mode - common in other editors)
        extra = {
          above = "gcO",  -- Comment line above
          below = "gco",  -- Comment line below
          eol = "gcA",    -- Comment at end of line
        },
      })

      -- Ctrl-/ to toggle comment (like VS Code)
      vim.keymap.set("n", "<C-/>", "gcc", { desc = "Toggle comment", remap = true })
      vim.keymap.set("v", "<C-/>", "gc", { desc = "Toggle comment", remap = true })
      vim.keymap.set("i", "<C-/>", "<Esc>gcca", { desc = "Toggle comment", remap = true })
    end,
  },

  -- Surround (ys, ds, cs for quotes, brackets, tags)
  {
    "kylechui/nvim-surround",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },

    config = function()
      require("nvim-surround").setup({
        -- Default keymaps are good:
        -- ys{motion}{char} - Add surround
        -- ds{char}         - Delete surround
        -- cs{old}{new}     - Change surround
      })
    end,
  },

  -- Better increment/decrement (supports more than just numbers)
  {
    "monaqa/dial.nvim",
    keys = {
      {
        "<C-a>",
        function()
          require("dial.map").manipulate("increment", "normal")
        end,
        desc = "Increment",
      },
      {
        "<C-x>",
        function()
          require("dial.map").manipulate("decrement", "normal")
        end,
        desc = "Decrement",
      },
      {
        "g<C-a>",
        function()
          require("dial.map").manipulate("increment", "gnormal")
        end,
        desc = "Increment (sequence)",
      },
      {
        "g<C-x>",
        function()
          require("dial.map").manipulate("decrement", "gnormal")
        end,
        desc = "Decrement (sequence)",
      },
    },

    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,   -- Numbers: 0, 1, 2, ...
          augend.integer.alias.hex,       -- Hex: 0x00, 0x01, ...
          augend.date.alias["%Y/%m/%d"],  -- Dates: 2024/01/01
          augend.constant.alias.bool,     -- true/false
          augend.semver.alias.semver,     -- Versions: 1.2.3
        },
      })
    end,
  },

  -- Text case conversion (snake_case, camelCase, etc.)
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = { "BufReadPost", "BufNewFile" },

    config = function()
      require("textcase").setup({})

      -- Load telescope extension
      require("telescope").load_extension("textcase")

      -- Keymaps
      vim.keymap.set("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Text case conversion" })
      vim.keymap.set("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Text case conversion" })
    end,
  },

  -- Better text objects (arguments, indent, etc.)
  {
    "echasnovski/mini.ai",
    version = false,
    event = { "BufReadPost", "BufNewFile" },

    config = function()
      require("mini.ai").setup({
        -- Custom text objects:
        -- a = argument/parameter
        -- i = indent
        -- f = function
        -- c = class
        -- etc.
      })
    end,
  },

  -- Jump to any location on screen with 2 keystrokes
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    event = { "BufReadPost", "BufNewFile" },

    config = function()
      -- Setup keymaps manually (add_default_mappings is deprecated)
      vim.keymap.set("n", "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
      vim.keymap.set("n", "S", "<Plug>(leap-backward)", { desc = "Leap backward" })
      vim.keymap.set({ "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
      vim.keymap.set({ "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })
      vim.keymap.set("n", "gs", "<Plug>(leap-from-window)", { desc = "Leap from window" })
    end,
  },

  -- Undo tree (visual history of changes)
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" },
    },
  },
}

--[[
  EDITING ENHANCEMENTS:

  COMMENTING:

  gcc       - Toggle comment on current line
  gc{motion} - Comment motion (gcap = comment paragraph)
  gcip      - Comment inside paragraph
  gcG       - Comment from here to end of file

  Visual mode:
  gc        - Toggle comment on selection

  Ctrl-/    - Toggle comment (like VS Code)

  Examples:
  - gcc on "let x = 5" → "// let x = 5"
  - gc3j comments current line + next 3
  - gcG comments from cursor to end of file

  SURROUND:

  Add surround:
  ysiw"     - Surround word with "quotes"
  yss)      - Surround entire line with (parentheses)
  ysW]      - Surround WORD with [brackets]

  Delete surround:
  ds"       - Delete surrounding "quotes"
  ds)       - Delete surrounding (parentheses)
  dst       - Delete surrounding HTML tag

  Change surround:
  cs"'      - Change "quotes" to 'quotes'
  cs)]      - Change (parens) to [brackets]
  cst<div>  - Change tag to <div>

  Examples:
  - "hello" + ds" → hello
  - hello + ysiw" → "hello"
  - (text) + cs)] → [text]
  - <p>text</p> + cst<div> → <div>text</div>

  INCREMENT/DECREMENT:

  Ctrl-a    - Increment number/bool/date
  Ctrl-x    - Decrement number/bool/date

  Works on:
  - Numbers: 0 → 1, 99 → 100
  - Hex: 0x0f → 0x10
  - Booleans: true → false
  - Dates: 2024/01/01 → 2024/01/02
  - Versions: 1.2.3 → 1.2.4

  TEXT CASE:

  ga.       - Open case conversion menu

  Options:
  - snake_case
  - camelCase
  - PascalCase
  - SCREAMING_SNAKE_CASE
  - kebab-case
  - dot.case

  Example:
  1. Put cursor on "myVariable"
  2. Press ga.
  3. Select snake_case
  4. Result: "my_variable"

  LEAP (JUMP):

  s{char}{char}  - Jump forward to location
  S{char}{char}  - Jump backward to location

  Example:
  1. Press s
  2. Type first 2 letters of word you want to jump to
  3. Neovim shows labels
  4. Type label to jump

  Way faster than counting with w/b or using search!

  UNDO TREE:

  <leader>u  - Open undo tree

  Navigate through ALL changes (not just linear undo):
  - See every version of your file
  - Jump to any previous state
  - Visual tree of changes

  TEXT OBJECTS (mini.ai):

  Enhanced text objects:
  via       - Select inside argument
  vaa       - Select around argument
  vii       - Select inside indent
  vai       - Select around indent

  Examples:
  - foo(bar, |baz, qux) + via → selects "baz"
  - foo(bar, |baz, qux) + vaa → selects ", baz"
  - daa deletes argument
  - cia changes argument

  TIPS:

  - Comment.nvim respects language (// for Rust, # for Python, etc.)
  - Surround is invaluable for editing quotes/brackets
  - Leap is faster than any other motion (try it!)
  - Undo tree saves you when you need to undo an undo

  WORKFLOW EXAMPLES:

  Change "hello" to 'hello':
  - Move cursor inside quotes
  - cs"'

  Comment out function:
  - vaf (select around function - from treesitter)
  - gc

  Jump to error on line 200:
  - s{first 2 chars of word on line 200}
  - Type label

  CUSTOMIZATION:

  Comment format:
  - Handled automatically by Comment.nvim
  - Uses tree-sitter for context-aware comments

  Surround chars:
  - Can add custom surrounds in config
  - See nvim-surround docs

  Leap labels:
  - Can customize which keys are used for labels
  - Default is safe and ergonomic
--]]
