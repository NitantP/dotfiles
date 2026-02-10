--[[
  Claude Code Integration

  Integrates Claude Code (AI coding assistant) into Neovim.
  Allows you to chat with Claude directly from your editor.

  What it does:
  - Send code/questions to Claude
  - Get AI assistance without leaving Neovim
  - Apply code suggestions directly

  NOTE: This plugin requires the Claude Code CLI to be installed.
  Install: https://github.com/anthropics/claude-code
--]]

return {
  {
    "coder/claudecode.nvim",

    dependencies = { "folke/snacks.nvim" },

    config = function()
      require("claudecode").setup({
        server = {
          -- Port range for WebSocket server
          port_range = { min = 10000, max = 65535 },

          -- Automatically start server
          auto_start = true,

          -- Log level: "trace", "debug", "info", "warn", "error"
          log_level = "info",
        },

        -- Terminal command to launch Claude Code CLI
        terminal_cmd = "claude",
      })
    end,

    keys = {
      -- Toggle Claude Code
      { "<leader>ac", "<cmd>ClaudeCode<cr>",        desc = "Claude: Toggle" },

      -- Focus Claude Code window
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",   desc = "Claude: Focus" },

      -- Open Claude Code chat
      { "<leader>ai", "<cmd>ClaudeCode<cr>",        desc = "Claude: Chat" },

      -- Add current buffer to Claude context
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",   desc = "Claude: Add current buffer" },

      -- Send VISUAL selection to Claude context
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",    desc = "Claude: Send selection",    mode = "v" },

      -- Send file to Claude context
      { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Claude: Add file",          ft = { "oil" } }
    },
  },

  --[[
  ALTERNATIVE: avante.nvim (More feature-rich Claude integration)

  Uncomment to use this instead (comment out claude.vim above):

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },

    build = "make",

    config = function()
      require("avante").setup({
        provider = "claude",
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-5",
          temperature = 0,
          max_tokens = 4096,
        },
        behaviour = {
          auto_suggestions = false,  -- Set to true for inline suggestions
          auto_set_highlight_group = true,
          auto_set_keymaps = true,
        },
        mappings = {
          ask = "<leader>aa",
          edit = "<leader>ae",
          refresh = "<leader>ar",
          diff = {
            ours = "co",
            theirs = "ct",
            all_theirs = "ca",
            both = "cb",
            cursor = "cc",
            next = "]x",
            prev = "[x",
          },
        },
      })
    end,

    keys = {
      { "<leader>aa", mode = { "n", "v" }, desc = "Avante: Ask" },
      { "<leader>ae", mode = "v", desc = "Avante: Edit" },
      { "<leader>ar", mode = "n", desc = "Avante: Refresh" },
    },
  },
  --]]
}

--[[
  CLAUDE CODE USAGE:

  This plugin uses the official Claude Code integration via WebSocket protocol,
  providing the same experience as the VS Code extension.

  BASIC WORKFLOW:

  1. Open Claude Code: <leader>ac or <leader>ai
  2. Claude Code CLI automatically connects to Neovim
  3. Full IDE integration (read/edit files, run commands, etc.)
  4. Chat with Claude directly in the terminal or split window

  KEYMAPS:

  <leader>ac  - Toggle Claude Code window
  <leader>af  - Focus Claude Code window
  <leader>ai  - Open Claude Code chat
  <leader>ab  - Add current buffer to Claude context
  <leader>as  - Send VISUAL selection to Claude context

  COMMANDS:

  :ClaudeCode       - Toggle Claude Code window
  :ClaudeCodeFocus  - Focus on Claude Code window

  HOW IT WORKS:

  The plugin creates a WebSocket server that Claude Code CLI connects to.
  This implements the same MCP (Model Context Protocol) as VS Code, giving
  Claude full access to your editor:
  - Read and edit any file
  - Execute terminal commands
  - Navigate your codebase
  - Apply code changes

  SETUP:

  1. Install Claude Code CLI:
     curl -fsSL https://raw.githubusercontent.com/anthropics/claude-code/main/install.sh | sh

  2. Install snacks.nvim dependency (already in config):
     This plugin requires folke/snacks.nvim for UI components

  3. Start Neovim and launch Claude Code:
     <leader>ac

  4. The WebSocket server starts automatically
     Claude Code CLI will detect and connect to Neovim

  CONFIGURATION:

  You can customize the setup in the config function above:
  - port_range: WebSocket server port range (default: 10000-65535)
  - auto_start: Auto-start server when Neovim launches (default: true)
  - log_level: Logging verbosity (trace, debug, info, warn, error)
  - terminal_cmd: Command to launch Claude Code CLI (default: "claude")

  TIPS:

  - Claude has full access to your editor, so be specific in requests
  - You can ask Claude to read files, make changes, run tests, etc.
  - The integration is bidirectional - changes sync automatically
  - Use natural language to describe what you want
  - Claude can see your entire codebase context

  TROUBLESHOOTING:

  Plugin not loading?
  - Check Claude Code CLI is installed: `which claude`
  - Ensure snacks.nvim dependency is installed: :Lazy
  - Restart Neovim
  - Check :messages for errors

  Connection issues?
  - Check if WebSocket server started: :messages
  - Verify port range is available (not blocked by firewall)
  - Try manually starting: :ClaudeCode
  - Check log_level = "debug" for detailed logs

  Claude not responding?
  - Ensure you're authenticated: `claude auth login`
  - Check internet connection
  - Verify API key/session is valid

  PRIVACY:

  - Code is sent to Anthropic's API
  - Claude Code uses the same privacy policy as Claude
  - Don't send sensitive data (secrets, credentials, etc.)
  - See: https://www.anthropic.com/privacy
--]]
