--[[
  Terminal Integration

  Better terminal experience in Neovim:
  - Floating terminal (toggle with keymap)
  - Multiple terminal instances
  - Send commands from editor to terminal
--]]

return {
  -- Toggleterm: Better terminal integration
  {
    "akinsho/toggleterm.nvim",
    version = "*",

    keys = {
      { "<C-\\>",     desc = "Toggle terminal" },
      { "<leader>tf", desc = "Toggle floating terminal" },
      { "<leader>th", desc = "Toggle horizontal terminal" },
      { "<leader>tv", desc = "Toggle vertical terminal" },
    },

    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,

        open_mapping = [[<C-\>]], -- Ctrl-\ to toggle
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = "float", -- float, horizontal, vertical, tab
        close_on_exit = true,
        shell = vim.o.shell,

        float_opts = {
          border = "curved", -- single, double, shadow, curved
          width = function()
            return math.floor(vim.o.columns * 0.9)
          end,
          height = function()
            return math.floor(vim.o.lines * 0.9)
          end,
        },

        -- Terminal mode mappings for window navigation
        on_open = function(term)
          local opts = { buffer = term.bufnr, noremap = true, silent = true }
          -- Double ESC to exit terminal mode (back to normal mode)
          vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], opts)
          -- Window navigation from terminal mode (exits insert mode first)
          vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
          vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
          vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
          vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
        end,
      })

      -- Window navigation in normal mode (for consistency)
      vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })
      vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate to bottom window" })
      vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate to top window" })
      vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })

      -- Custom terminal keymaps
      local Terminal = require("toggleterm.terminal").Terminal

      -- Floating terminal
      local float_term = Terminal:new({
        direction = "float",
        hidden = true,
      })

      function _float_toggle()
        float_term:toggle()
      end

      vim.keymap.set("n", "<leader>tf", "<cmd>lua _float_toggle()<CR>", { desc = "Toggle floating terminal" })

      -- Horizontal terminal
      local horizontal_term = Terminal:new({
        direction = "horizontal",
        hidden = true,
      })

      function _horizontal_toggle()
        horizontal_term:toggle()
      end

      vim.keymap.set("n", "<leader>th", "<cmd>lua _horizontal_toggle()<CR>", { desc = "Toggle horizontal terminal" })

      -- Vertical terminal
      local vertical_term = Terminal:new({
        direction = "vertical",
        hidden = true,
      })

      function _vertical_toggle()
        vertical_term:toggle()
      end

      vim.keymap.set("n", "<leader>tv", "<cmd>lua _vertical_toggle()<CR>", { desc = "Toggle vertical terminal" })

      -- Lazygit integration (if lazygit is installed)
      if vim.fn.executable("lazygit") == 1 then
        local lazygit = Terminal:new({
          cmd = "lazygit",
          direction = "float",
          hidden = true,
        })

        function _lazygit_toggle()
          lazygit:toggle()
        end

        vim.keymap.set("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", { desc = "Toggle lazygit" })
      end

      -- Python REPL (if you work with Python)
      local python = Terminal:new({
        cmd = "python3",
        direction = "float",
        hidden = true,
      })

      function _python_toggle()
        python:toggle()
      end

      vim.keymap.set("n", "<leader>tp", "<cmd>lua _python_toggle()<CR>", { desc = "Toggle Python REPL" })

      -- Node REPL (if you work with JavaScript/TypeScript)
      local node = Terminal:new({
        cmd = "node",
        direction = "float",
        hidden = true,
      })

      function _node_toggle()
        node:toggle()
      end

      vim.keymap.set("n", "<leader>tn", "<cmd>lua _node_toggle()<CR>", { desc = "Toggle Node REPL" })
    end,
  },
}

--[[
  TERMINAL USAGE:

  BASIC:

  Ctrl-\    - Toggle terminal (floating by default)
  Esc Esc   - Exit terminal mode (back to normal mode)
  Ctrl-\ again - Close terminal

  DIFFERENT LAYOUTS:

  <leader>tf - Floating terminal (popup in center)
  <leader>th - Horizontal terminal (split below)
  <leader>tv - Vertical terminal (split right)

  WINDOW NAVIGATION:

  Ctrl-h    - Navigate to left window
  Ctrl-j    - Navigate to bottom window
  Ctrl-k    - Navigate to top window
  Ctrl-l    - Navigate to right window
  (Works from terminal mode or normal mode)

  INSIDE TERMINAL:

  Esc Esc   - Enter normal mode (can navigate, copy, etc.)
  i or a    - Back to insert mode (typing in terminal)
  Ctrl-\    - Close terminal
  Ctrl-h/j/k/l - Switch to editor window (exits insert mode automatically)

  SPECIAL TERMINALS:

  <leader>gg - Lazygit (if installed)
  <leader>tp - Python REPL
  <leader>tn - Node REPL

  WORKFLOW EXAMPLES:

  Quick command:
  1. Ctrl-\ to open terminal
  2. Run command (cargo build, npm test, etc.)
  3. Ctrl-\ to close (or leave open)

  Interactive session:
  1. <leader>tp for Python REPL
  2. Test code snippets
  3. Ctrl-\ when done

  Git workflow (with lazygit):
  1. <leader>gg to open lazygit
  2. Stage files, commit, push (all in TUI)
  3. Ctrl-\ to close

  Copy from terminal:
  1. Open terminal, run command
  2. Esc Esc to enter normal mode
  3. Use vim motions to select text (v, y, etc.)
  4. Ctrl-h/j/k/l to navigate to editor window
  5. Paste with p

  TIPS:

  - Terminals persist (don't close when you switch files)
  - Can have multiple terminals (numbered 1, 2, 3, etc.)
  - Use :ToggleTerm to open by number: :ToggleTerm 2
  - Ctrl-\ is muscle memory from many terminals

  ADDING CUSTOM TERMINALS:

  Want a Rust REPL?

  local rust_repl = Terminal:new({
    cmd = "evcxr",  -- Rust REPL
    direction = "float",
    hidden = true,
  })

  function _rust_toggle()
    rust_repl:toggle()
  end

  vim.keymap.set("n", "<leader>tr", "<cmd>lua _rust_toggle()<CR>", { desc = "Toggle Rust REPL" })

  LAZYGIT SETUP:

  Lazygit is a terminal UI for git (much nicer than command line).

  Install:
  - macOS: brew install lazygit
  - Linux: see https://github.com/jesseduffield/lazygit

  Use:
  1. <leader>gg
  2. Navigate with hjkl
  3. Stage with space
  4. Commit with c
  5. Push with P
  6. Pull with p

  COMMANDS:

  :ToggleTerm              - Toggle default terminal
  :ToggleTerm direction=horizontal - Open horizontal terminal
  :ToggleTerm size=40      - Open terminal with specific size
  :<number>ToggleTerm      - Toggle terminal by number

  MULTIPLE TERMINALS:

  You can have multiple terminals open:

  :1ToggleTerm - Terminal 1
  :2ToggleTerm - Terminal 2
  :3ToggleTerm - Terminal 3

  Example:
  - Terminal 1: cargo watch (auto-rebuild)
  - Terminal 2: running application
  - Terminal 3: general commands

  TROUBLESHOOTING:

  Can't exit terminal?
  - Press Esc Esc to enter normal mode
  - Then Ctrl-\ to close

  Terminal too small?
  - Adjust size in config (size = 15 for horizontal)
  - Or resize with Ctrl-W + < > (vertical) or + - (horizontal)

  Terminal not showing?
  - :ToggleTerm to force open
  - :messages to see errors
--]]
