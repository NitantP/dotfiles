--[[
  Code Formatting with conform.nvim

  What it does:
  - Format code on save or manually
  - Supports multiple formatters per language
  - Integrates with Mason for automatic formatter installation
  - Preserves cursor position and folds

  How it works:
  1. Mason installs formatters (stylua, prettier, black, etc.)
  2. conform.nvim uses these formatters to format your code
  3. Formatters run either manually or on save

  Supported languages (configured below):
  - Lua (stylua)
  - Python (isort, black)
  - JavaScript/TypeScript (prettier)
  - Rust (rustfmt)
  - Go (gofmt, goimports)
  - JSON, YAML, Markdown, HTML, CSS (prettier)
--]]

return {
  -- conform.nvim: Main formatter plugin
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },

    config = function()
      local conform = require("conform")

      conform.setup({
        -- Define formatters by filetype
        formatters_by_ft = {
          -- Lua
          lua = { "stylua" },

          -- Python
          python = { "isort", "black" },

          -- JavaScript/TypeScript
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },

          -- Web
          html = { "prettier" },
          css = { "prettier" },
          scss = { "prettier" },
          json = { "prettier" },
          jsonc = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },

          -- Rust (rustfmt via LSP is usually preferred)
          rust = { "rustfmt" },

          -- Go
          go = { "gofmt", "goimports" },

          -- Haskell
          haskell = { "ormolu" },

          -- Shell
          bash = { "shfmt" },
          sh = { "shfmt" },

          -- Add more formatters here as needed
          -- Find available formatters: https://github.com/stevearc/conform.nvim#formatters
        },

        -- Format on save (optional - can be toggled)
        format_on_save = {
          -- Time to wait for formatting (in milliseconds)
          timeout_ms = 500,

          -- Use LSP formatting as fallback if no formatter available
          lsp_format = "fallback",
        },

        -- Format options
        format_opts = {
          -- Stop after first successful formatter
          stop_after_first = true,
        },
      })

      -- Keymap: Format current buffer manually
      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        conform.format({
          lsp_format = "fallback",
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format code" })

      -- Keymap: Toggle format on save
      vim.keymap.set("n", "<leader>cF", function()
        if vim.g.conform_format_on_save then
          vim.g.conform_format_on_save = false
          conform.setup({ format_on_save = nil })
          print("Format on save: disabled")
        else
          vim.g.conform_format_on_save = true
          conform.setup({
            format_on_save = {
              timeout_ms = 500,
              lsp_format = "fallback",
            },
          })
          print("Format on save: enabled")
        end
      end, { desc = "Toggle format on save" })
    end,
  },

  -- Note: Formatters need to be installed manually via Mason
  -- Open Mason with :Mason and search for formatters like:
  --   - stylua (Lua)
  --   - prettier (JS/TS/HTML/CSS/JSON/YAML/Markdown)
  --   - black, isort (Python)
  --   - shfmt (Shell)
  --   - clang-format (C/C++)
  -- Type '/' in Mason to search, then 'i' to install
}

--[[
  FORMATTER USAGE:

  MANUAL FORMATTING:

  <leader>cf  - Format current buffer (or selection in visual mode)

  Works in both normal mode (formats whole file) and visual mode (formats selection).

  FORMAT ON SAVE:

  <leader>cF  - Toggle automatic format on save

  By default, format on save is ENABLED. Toggle it off if you prefer manual formatting.

  ADDING NEW FORMATTERS:

  1. Find the formatter name at:
     https://github.com/stevearc/conform.nvim#formatters

  2. Add to formatters_by_ft table above:
     filetype = { "formatter_name" },

  3. Install the formatter via Mason:
     - :Mason
     - Type / to search
     - Find your formatter (e.g., "prettier")
     - Press i to install

  4. Restart Neovim or reload config

  Example (adding C++ formatting):
  cpp = { "clang-format" },

  MULTIPLE FORMATTERS:

  You can chain multiple formatters:
  python = { "isort", "black" },

  This runs isort first (organize imports), then black (format code).

  FORMATTER PRIORITY:

  If you have multiple formatters and want to try them in order:
  javascript = { "prettierd", "prettier", stop_after_first = true },

  This tries prettierd first (faster), falls back to prettier if not available.

  DISABLING FORMAT ON SAVE:

  If you want to disable format on save entirely:
  1. <leader>cF to toggle it off
  OR
  2. Comment out the format_on_save option in the config above

  LSP FORMATTING:

  If no formatter is configured for a filetype, conform will fall back
  to LSP formatting (if the LSP supports it). This is controlled by:
  lsp_format = "fallback"

  COMMANDS:

  :ConformInfo  - Show formatter info for current buffer

  TROUBLESHOOTING:

  Formatter not working?
  1. :ConformInfo - check if formatter is available
  2. :Mason - check if formatter is installed
  3. :messages - look for error messages

  Formatter not installed?
  1. :Mason - install manually: /prettier (press i to install)
  2. :MasonLog - see installation errors
  3. Check prerequisites (node.js for prettier, etc.)
  4. Some formatters come with language toolchains (rustfmt, gofmt)

  Wrong formatting?
  1. Check formatter config (per-project .prettierrc, etc.)
  2. Some formatters respect project config files
  3. Adjust formatter options in conform config if needed

  Format on save not working?
  1. Check if it's enabled: :lua print(vim.g.conform_format_on_save)
  2. Toggle it: <leader>cF
  3. Check :messages for errors
  4. Some files might timeout - increase timeout_ms

  TIPS:

  - Most formatters respect project config files (.prettierrc, .rustfmt.toml, etc.)
  - Format on save is convenient but can be slow for large files
  - Use <leader>cf for manual formatting when needed
  - Some LSPs format on save by default (rust-analyzer) - conform works alongside them
  - Formatting preserves cursor position and undo history

  EXAMPLES:

  Python project:
  1. Open .py file
  2. Mason auto-installs black and isort
  3. Save file - automatically formats
  4. Or <leader>cf to format manually

  JavaScript project:
  1. Create .prettierrc in project root
  2. Open .js file
  3. Mason auto-installs prettier
  4. Formatting respects your .prettierrc config

  Format selection:
  1. Select code in visual mode (V or v)
  2. <leader>cf
  3. Only selection is formatted

  CUSTOMIZATION:

  Timeout:
  - Increase timeout_ms if formatters are slow

  Async formatting:
  - Set async = true in format() call for non-blocking format

  Custom formatters:
  - Add to formatters table in conform config
  - See conform.nvim docs for custom formatter setup

  Per-project config:
  - Most formatters support project config files
  - .prettierrc for prettier
  - .rustfmt.toml for rustfmt
  - pyproject.toml for black
  - etc.
--]]
