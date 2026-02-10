--[[
  Treesitter - Better Syntax Highlighting

  What it does:
  - Parses your code into a syntax tree (understands code structure)
  - Provides MUCH better syntax highlighting than regex-based highlighters
  - Enables smart features: better folding, text objects, etc.

  Why you need it:
  - Default syntax highlighting often breaks or is inaccurate
  - Required by many modern plugins
  - Fast (incremental parsing)

  Note: Using master branch due to system GLIBC compatibility limitations.
  The new rewrite requires tree-sitter-cli v0.26.1+ which needs GLIBC 2.39+.
--]]

return {
  {
    "nvim-treesitter/nvim-treesitter",

    -- Use master branch (stable API) due to system limitations
    branch = "master",

    -- Update parsers on plugin update
    build = ":TSUpdate",

    -- Load immediately, not lazily
    lazy = false,

    -- Textobjects dependency
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "master",
      },
    },

    config = function()
      require("nvim-treesitter.configs").setup({
        -- Install parsers for these languages
        ensure_installed = {
          "lua",        -- Neovim config
          "vim",        -- Vim help files
          "vimdoc",     -- Vim documentation
          "rust",       -- Rust
          "python",     -- Python
          "typescript", -- TypeScript
          "javascript", -- JavaScript (needed by TypeScript)
          "tsx",        -- TypeScript React
          "haskell",    -- Haskell
          "json",       -- JSON
          "yaml",       -- YAML
          "toml",       -- TOML (Rust configs)
          "markdown",   -- Markdown
          "markdown_inline", -- Inline markdown
          "bash",       -- Shell scripts
          "html",       -- HTML
          "css",        -- CSS
        },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- Enable syntax highlighting
        highlight = {
          enable = true,

          -- Disable Treesitter for very large files (performance)
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          additional_vim_regex_highlighting = false,
        },

        -- Enable smart indentation
        indent = {
          enable = true,
          -- Disable for languages where it's problematic
          disable = { "python" },  -- Python indentation is better with vim's default
        },

        -- Incremental selection based on syntax tree
        -- Press Ctrl-Space to start, then keep pressing to expand
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",  -- backspace to shrink
          },
        },

        -- Treesitter text objects
        textobjects = {
          select = {
            enable = true,
            lookahead = true,  -- Automatically jump to next text object

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",  -- "a function" - select whole function
              ["if"] = "@function.inner",  -- "inside function" - select function body
              ["ac"] = "@class.outer",     -- "a class"
              ["ic"] = "@class.inner",     -- "inside class"
              ["aa"] = "@parameter.outer", -- "a argument"
              ["ia"] = "@parameter.inner", -- "inside argument"
            },
          },

          move = {
            enable = true,
            set_jumps = true,  -- Add to jumplist

            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
            },
          },
        },
      })

      -- Enable folding with treesitter
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
  },
}

--[[
  TREESITTER COMMANDS:

  :TSInstall <language>     - Install parser for language
  :TSUpdate                 - Update all parsers
  :TSUninstall <language>   - Remove parser
  :TSModuleInfo             - Show which modules are enabled

  USEFUL TEXT OBJECTS (after setup):

  vaf  - Select around function
  vif  - Select inside function
  daf  - Delete function
  yif  - Yank inside function
  cif  - Change inside function

  ]f   - Jump to next function
  [f   - Jump to previous function
  ]c   - Jump to next class
  [c   - Jump to previous class

  INCREMENTAL SELECTION:

  1. Press Ctrl-Space to start selection
  2. Keep pressing Ctrl-Space to expand to parent nodes
  3. Press Backspace to shrink selection

  TROUBLESHOOTING:

  If highlighting looks wrong:
  1. :TSUpdate to update parsers
  2. :TSModuleInfo to check if highlighting is enabled
  3. Try :TSDisable highlight then :TSEnable highlight

  FUTURE UPGRADE PATH:

  When your system supports GLIBC 2.39+, you can upgrade to the new rewrite:
  1. Remove the branch = "master" lines
  2. Install tree-sitter-cli v0.26.1+ (npm install -g tree-sitter-cli)
  3. Update configuration to use new API (see nvim-treesitter README)
--]]
