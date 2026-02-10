--[[
  Auto-Completion

  What it does:
  - Shows completion menu as you type
  - Integrates with LSP for smart completions
  - Supports snippets

  How to use:
  1. Start typing
  2. Menu appears automatically
  3. Ctrl-n / Ctrl-p to navigate (or arrow keys)
  4. Enter to select

  Sources (where completions come from):
  - LSP (language server)
  - Buffer (words from current file)
  - Path (file paths)
  - Snippets (code templates)
--]]

return {
  {
    "hrsh7th/nvim-cmp",

    -- Load in insert mode (when you start typing)
    event = "InsertEnter",

    dependencies = {
      -- Snippet engine (required by nvim-cmp)
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",  -- Optional, for better snippet support
        dependencies = {
          -- Pre-made snippets for various languages
          "rafamadriz/friendly-snippets",
        },
      },

      -- Completion sources
      "saadparwaiz1/cmp_luasnip",  -- Snippet completions
      "hrsh7th/cmp-nvim-lsp",      -- LSP completions
      "hrsh7th/cmp-buffer",        -- Buffer completions (words in file)
      "hrsh7th/cmp-path",          -- Path completions
      "hrsh7th/cmp-cmdline",       -- Command-line completions

      -- Icons in completion menu
      "onsails/lspkind.nvim",
    },

    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        -- Snippet engine
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        -- Completion menu appearance
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        -- Formatting (how items look in menu)
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",  -- Show icon + text
            maxwidth = 50,         -- Prevent menu from being too wide
            ellipsis_char = "...", -- Truncate long items

            -- Show where completion came from (LSP, buffer, etc.)
            menu = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            },
          }),
        },

        -- Keymaps
        mapping = cmp.mapping.preset.insert({
          -- Navigate completion menu
          ["<C-n>"] = cmp.mapping.select_next_item(),  -- Next item
          ["<C-p>"] = cmp.mapping.select_prev_item(),  -- Previous item

          -- Scroll documentation window
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),

          -- Accept completion
          ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- Enter to accept

          -- Ctrl-Space to trigger completion manually
          ["<C-Space>"] = cmp.mapping.complete(),

          -- Tab to jump to next snippet placeholder
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Shift-Tab to jump to previous snippet placeholder
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        -- Completion sources (in order of priority)
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },  -- LSP first (most relevant)
          { name = "luasnip", priority = 750 },    -- Snippets second
          { name = "buffer", priority = 500 },     -- Words from file
          { name = "path", priority = 250 },       -- File paths
        }),

        -- Experimental features
        experimental = {
          ghost_text = false,  -- Show preview of completion (can be distracting)
        },
      })

      -- Command-line completion
      -- Use buffer source for `/` and `?` (search)
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use path and cmdline sources for `:` (commands)
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
    end,
  },
}

--[[
  COMPLETION USAGE:

  BASIC:
  1. Start typing
  2. Menu appears automatically
  3. Use Ctrl-n / Ctrl-p (or arrows) to navigate
  4. Press Enter to accept

  KEYMAPS:
  Ctrl-n       - Next completion
  Ctrl-p       - Previous completion
  Enter        - Accept completion
  Ctrl-Space   - Trigger completion manually
  Ctrl-d/u     - Scroll documentation
  Tab          - Next item or jump to next snippet placeholder
  Shift-Tab    - Previous item or jump to previous snippet placeholder

  SNIPPETS:

  Snippets are code templates. Example in JavaScript:

  Type: for<Tab>
  Expands to:
    for (let i = 0; i < array.length; i++) {
      |
    }

  The cursor lands at `|`, ready to type. Press Tab to jump to next placeholder.

  Common snippets:
  - fn / func  = function
  - if         = if statement
  - for        = for loop
  - class      = class declaration

  COMPLETION SOURCES:

  [LSP]   - From language server (smart, context-aware)
  [Snip]  - Snippet templates
  [Buf]   - Words from current buffer
  [Path]  - File paths

  CUSTOMIZATION:

  Change completion behavior:
  - Auto-select first item: select = true (in <CR> mapping)
  - Enable ghost text: ghost_text = true
  - Change menu appearance: window.completion settings

  Add more sources:
  See https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources

  Example (add emoji completion):
  { name = "emoji" }  -- Add to sources, install hrsh7th/cmp-emoji

  TROUBLESHOOTING:

  Completion not working?
  1. Check LSP is running: :LspInfo
  2. Check sources are loaded: :CmpStatus
  3. Trigger manually: Ctrl-Space

  Too many/few suggestions?
  Adjust source priorities in `sources` config

  Want different keymaps?
  Change `mapping` table (common alternative: Tab/S-Tab instead of Ctrl-n/p)
--]]
