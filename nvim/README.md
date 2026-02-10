# Neovim Configuration

A fast, maintainable, and well-documented Neovim configuration focused on terminal-based development.

## Philosophy

This configuration prioritizes:
- **Understandability**: Every choice is documented and explained
- **Speed**: Fast startup with lazy-loading plugins
- **Maintainability**: Clean structure, easy to modify
- **Practicality**: Sensible defaults that just work

## Quick Start

1. **Backup your current config** (if you haven't already)
2. **Use this config**: `NVIM_APPNAME=nvim.claude nvim`
3. **Or replace your config**: `rm -rf ~/.config/nvim && mv ~/.config/nvim.claude ~/.config/nvim`

On first launch, lazy.nvim will automatically install all plugins. This may take a minute.

## Structure

```
~/.config/nvim.claude/
├── init.lua                    # Entry point - loads everything
├── lua/
│   ├── config/
│   │   ├── lazy.lua           # Plugin manager bootstrap
│   │   ├── options.lua        # Vim settings (line numbers, tabs, etc.)
│   │   └── keymaps.lua        # Keyboard shortcuts
│   └── plugins/
│       ├── colorscheme.lua    # High-contrast color theme
│       ├── treesitter.lua     # Syntax highlighting
│       ├── telescope.lua      # Fuzzy finder (fzf replacement)
│       ├── lsp.lua            # Language servers
│       ├── completion.lua     # Auto-completion
│       ├── git.lua            # Git integration
│       └── ui.lua             # UI enhancements
└── README.md                   # This file
```

## Language Support

This config includes LSP (Language Server Protocol) support for:
- **Rust**: rust-analyzer
- **Python**: pyright
- **TypeScript/JavaScript**: ts_ls (formerly tsserver)
- **Haskell**: haskell-language-server
- **Lua**: lua_ls

LSP provides:
- Go-to-definition (`gd`)
- Code completion
- Inline diagnostics (errors/warnings)
- Hover documentation (`K`)
- Code actions (`<leader>ca`)

## Key Bindings

Leader key is **space**.

### Essential Bindings

| Key | Action | Why |
|-----|--------|-----|
| `<space>` | Leader key | Standard convention, easy to reach |
| `<Esc>` | Clear search highlights | Clean up after searching |
| `<C-s>` | Save file | Muscle memory from other editors |

### Navigation

| Key | Action | Why |
|-----|--------|-----|
| `<C-h/j/k/l>` | Move between splits | Vim-style, no Ctrl-W prefix needed |
| `<C-d/u>` | Scroll half-page with cursor centered | Easier to track position |
| `<Tab>` / `<S-Tab>` | Next/previous buffer | Quick buffer switching |

### File Finding (Telescope)

| Key | Action | Why |
|-----|--------|-----|
| `<leader>ff` | Find files | Most common operation |
| `<leader>fg` | Live grep | Search in files |
| `<leader>fb` | Find buffers | Switch between open files |
| `<leader>fh` | Help tags | Search Neovim help |
| `<leader>fo` | Old files | Recently opened files |

### LSP (Language Server)

| Key | Action | Why |
|-----|--------|-----|
| `gd` | Go to definition | Standard LSP mapping |
| `gr` | Go to references | Find where something is used |
| `K` | Hover documentation | Standard vim mapping |
| `<leader>ca` | Code action | Fix errors, refactor |
| `<leader>rn` | Rename symbol | Refactor across project |
| `[d` / `]d` | Previous/next diagnostic | Navigate errors |

### Git (Fugitive)

| Key | Action | Why |
|-----|--------|-----|
| `<leader>gs` | Git status | Opens git interface |
| `<leader>gc` | Git commit | Commit changes |
| `<leader>gp` | Git push | Push to remote |

## How to Maintain This Config

### Adding a Plugin

1. Create a new file in `lua/plugins/` (e.g., `myplugin.lua`)
2. Return a table with the plugin spec:

```lua
return {
  "username/repo-name",

  -- Optional: only load when needed (faster startup)
  event = "VeryLazy",  -- or cmd = "CommandName", ft = "filetype", etc.

  -- Optional: plugin dependencies
  dependencies = {
    "other/plugin",
  },

  -- Optional: configuration
  config = function()
    require("plugin-name").setup({
      -- options here
    })
  end,
}
```

3. Restart Neovim - lazy.nvim will auto-install it

### Removing a Plugin

1. Delete the plugin file from `lua/plugins/`
2. Restart Neovim
3. Run `:Lazy clean` to remove the plugin

### Changing Settings

Edit `lua/config/options.lua`:
- Each option has a comment explaining what it does
- Options are grouped by category (display, editing, search, etc.)

### Adding Keymaps

Edit `lua/config/keymaps.lua`:
- Use `vim.keymap.set(mode, key, action, { desc = "Description" })`
- The `desc` field makes it searchable in Telescope (`<leader>fk`)

### Updating Plugins

Run `:Lazy update` in Neovim

### Checking Startup Time

Run `nvim --startuptime startup.log` then check the log file

## Plugin Choices Explained

### Why lazy.nvim?

- **Fast**: Only loads plugins when needed
- **Simple**: Declarative configuration
- **Popular**: Well-maintained, good docs

### Why Telescope over fzf?

- **Native**: Pure Lua, no external dependencies
- **Extensible**: Can search anything (files, buffers, LSP symbols, etc.)
- **Integrated**: Works seamlessly with other plugins

You can still use fzf if you prefer - just replace the telescope plugin.

### Why Treesitter?

- **Better syntax highlighting**: Understands code structure
- **Required for some plugins**: Text objects, folding, etc.
- **Fast**: Incremental parsing

### Why Mason for LSP?

- **Automatic installation**: No manual LSP setup
- **Cross-platform**: Works on any OS
- **Easy updates**: `:Mason` then press `U`

## Troubleshooting

### Plugins not loading?

Run `:Lazy` to see plugin status. Press `U` to update, `I` to install missing plugins.

### LSP not working?

1. Run `:LspInfo` to see if a server is attached
2. Run `:Mason` to check if language servers are installed
3. Install manually: `:MasonInstall rust-analyzer` (or other server)

### Slow startup?

1. Check startup time: `nvim --startuptime startup.log`
2. Look for plugins loading early - add lazy-loading:
   ```lua
   event = "VeryLazy",  -- or ft = "filetype", cmd = "Command"
   ```

### Something broke after updating?

1. Check lazy.nvim: `:Lazy`
2. Look for errors: `:messages`
3. Restore a plugin to older version:
   ```lua
   { "plugin/name", commit = "abc123" }  -- pin to specific commit
   ```

## Customization Ideas

### Change colorscheme

Edit `lua/plugins/colorscheme.lua`. Popular alternatives:
- `"folke/tokyonight.nvim"` - Modern, high contrast
- `"ellisonleao/gruvbox.nvim"` - Retro, warm colors
- `"rose-pine/neovim"` - Pastel, easy on eyes

### Add file tree

Create `lua/plugins/neo-tree.lua`:
```lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
  },
}
```

### Add more languages

Edit `lua/plugins/lsp.lua` and add to the `servers` table.

Find language servers at: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

## Resources

- **Neovim docs**: `:help` or https://neovim.io/doc/
- **lazy.nvim**: https://github.com/folke/lazy.nvim
- **LSP configs**: https://github.com/neovim/nvim-lspconfig
- **Plugin search**: https://dotfyle.com/plugins

## Philosophy Behind Choices

### Why not use a distribution (LunarVim, NvChad, etc.)?

Distributions are great for getting started, but:
- Hard to understand what's happening under the hood
- Difficult to debug when things break
- Lots of features you might not need

This config teaches you how Neovim works so you can maintain it yourself.

### Why Lua over Vimscript?

- **Faster**: Lua is compiled, Vimscript is interpreted
- **Modern**: Neovim's future is in Lua
- **Readable**: More like traditional programming

### Why these specific defaults?

Each option in `options.lua` is chosen for:
- **Ergonomics**: Makes editing easier
- **Standards**: Matches modern editor expectations
- **Performance**: Doesn't slow down Neovim

You can change any of them - they're just starting points.
