--[[
  LSP (Language Server Protocol)

  What it does:
  - Go-to-definition, find references, rename
  - Auto-completion
  - Inline diagnostics (errors/warnings)
  - Hover documentation
  - Code actions (quick fixes)

  How it works:
  1. Mason installs language servers
  2. nvim-lspconfig configures them
  3. Neovim communicates with servers via LSP

  Supported languages (configured below):
  - Rust (rust-analyzer)
  - Python (pyright)
  - TypeScript/JavaScript (ts_ls)
  - Haskell (haskell-language-server)
  - Lua (lua_ls)
--]]

return {
  {
    "neovim/nvim-lspconfig",

    -- Load LSP when editing files
    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
      -- Mason: Automatically install LSP servers
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP (shows progress in bottom right)
      { "j-hui/fidget.nvim", opts = {} },

      -- Additional Lua completion for Neovim API
      { "folke/neodev.nvim", opts = {} },
    },

    config = function()
      --[[
        This function runs when an LSP attaches to a buffer.
        It sets up keybindings and other buffer-specific settings.
      --]]
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          -- Helper function to set keymaps for this buffer only
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Navigation
          map("gd", require("telescope.builtin").lsp_definitions, "Go to definition")
          map("gr", require("telescope.builtin").lsp_references, "Go to references")
          map("gI", require("telescope.builtin").lsp_implementations, "Go to implementation")
          map("gy", require("telescope.builtin").lsp_type_definitions, "Go to type definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")

          -- Symbols (functions, variables, etc. in file)
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document symbols")
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace symbols")

          -- Documentation
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<C-s>", vim.lsp.buf.signature_help, "Signature help")

          -- Actions
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")

          -- Diagnostics (errors/warnings)
          map("<leader>d", vim.diagnostic.open_float, "Show diagnostic")

          -- Highlight references of word under cursor
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      --[[
        LSP Capabilities
        These tell the language server what features Neovim supports.
        nvim-cmp adds completion capabilities.
      --]]
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      --[[
        Language Servers to Install

        Add your language server here. Find servers at:
        https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
      --]]
      local servers = {
        -- Rust
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true, -- Enable all Cargo features
              },
              checkOnSave = {
                command = "clippy", -- Use clippy for extra lints
              },
            },
          },
        },

        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic", -- basic, strict, or off
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },

        -- TypeScript/JavaScript
        ts_ls = {}, -- Default settings are fine

        -- Haskell
        -- Note: hls (haskell-language-server) has installation issues via Mason
        -- Install manually: ghcup install hls
        -- Then it will work automatically when you open Haskell files
        -- Uncomment below if you have hls installed manually:
        -- hls = {
        --   settings = {
        --     haskell = {
        --       formattingProvider = "ormolu",
        --     },
        --   },
        -- },

        -- Lua (for Neovim config)
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                -- Tell lua_ls about Neovim runtime files
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                -- Don't complain about `vim` global
                globals = { "vim" },
              },
            },
          },
        },
      }

      --[[
        Setup Mason (LSP installer)
      --]]
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      -- Ensure servers are installed
      local ensure_installed = vim.tbl_keys(servers)
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup({
        ensure_installed = ensure_installed,
        automatic_installation = true, -- Auto-install servers when opening files
        handlers = {
          -- Default handler (for servers without custom config)
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })

      --[[
        Diagnostic Configuration

        Controls how errors/warnings are displayed
      --]]
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●", -- Could be '■', '▎', 'x', etc.
          spacing = 4,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
          },
        },
        underline = true,
        update_in_insert = false, -- Don't update diagnostics while typing
        severity_sort = true,     -- Sort by severity (errors first)
        float = {
          border = "rounded",
          source = "always", -- Show source (e.g., "rust-analyzer")
          header = "",
          prefix = "",
        },
      })

      -- Configure LSP float windows with rounded borders
      local border_style = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      }

      -- Override LSP handlers to use borders
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = border_style,
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = border_style,
      })

      -- Set FloatBorder highlight to yellow (matches completion window)
      vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#e5c07b", bg = "NONE" })
    end,
  },
}

--[[
  LSP USAGE:

  NAVIGATION:
  gd          - Go to definition (jump to where something is defined)
  gr          - Go to references (find all uses of something)
  gI          - Go to implementation
  K           - Show documentation (hover)
  <C-k>       - Show function signature (while typing function call)

  ACTIONS:
  <leader>ca  - Code actions (quick fixes, refactoring)
  <leader>rn  - Rename symbol (refactor across project)

  DIAGNOSTICS:
  [d          - Previous diagnostic
  ]d          - Next diagnostic
  <leader>d   - Show diagnostic details

  SYMBOLS:
  <leader>ds  - Document symbols (functions, classes in current file)
  <leader>ws  - Workspace symbols (search symbols across project)

  COMMANDS:
  :LspInfo              - Show LSP status
  :LspRestart           - Restart LSP server
  :Mason                - Open Mason (install/update language servers)
  :MasonInstall <name>  - Install a language server

  ADDING LANGUAGES:

  1. Find the server name at:
     https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers

  2. Add to the `servers` table above:
     servername = {},  -- Use {} for default config

  3. Restart Neovim - Mason will auto-install it

  Example (adding Go support):
  gopls = {},  -- Add this to servers table

  TROUBLESHOOTING:

  LSP not working?
  1. :LspInfo - check if server is attached
  2. :Mason - check if server is installed
  3. :messages - look for error messages

  Server not installing?
  1. Check you have the prerequisites (compiler, etc.)
  2. :MasonLog - see installation errors
  3. Install manually: :MasonInstall servername

  Wrong diagnostics?
  1. Check server config (settings = {...})
  2. Restart LSP: :LspRestart
  3. Check server docs: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--]]
