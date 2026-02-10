# Quick Start Guide

Get up and running with your new Neovim config in 5 minutes!

## Installation

### Option 1: Try it without touching your current config

```bash
NVIM_APPNAME=nvim.claude nvim
```

This opens Neovim using the new config without affecting your current setup.

### Option 2: Replace your current config

```bash
# Backup your current config (IMPORTANT!)
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.config/nvim.claude ~/.config/nvim

# Now just run nvim normally
nvim
```

### Option 3: Create an alias (best of both worlds)

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
alias nvim-new='NVIM_APPNAME=nvim.claude nvim'
```

Then use `nvim-new` for the new config, `nvim` for the old one.

## First Launch

When you first open Neovim with the new config:

1. **Wait for plugins to install** (this happens automatically via lazy.nvim)
   - You'll see a window showing download progress
   - Takes about 1-2 minutes
   - Press `q` when done

2. **Language servers will install automatically** when you open files
   - Rust file → rust-analyzer installs
   - Python file → pyright installs
   - etc.

3. **Optional: Pre-install language servers**
   ```
   :Mason
   ```
   Then press `I` next to servers you want to install.

## Essential Keybindings (Muscle Memory)

Start with these - you can learn the rest later:

| Key | Action | Why you need it |
|-----|--------|-----------------|
| `<Space>` | Leader key | Prefix for most commands |
| `<Space>ff` | Find files | Essential for navigation |
| `<Space>fg` | Find in files (grep) | Search across project |
| `<Space>fb` | Find buffers | Switch between open files |
| `<Ctrl-\>` | Toggle terminal | Quick terminal access |
| `gcc` | Toggle comment | Comment/uncomment code |
| `K` | Show documentation | LSP hover info |
| `gd` | Go to definition | Jump to code definition |

That's it! These 8 keybindings will get you 80% of the way there.

## Your First Session

Let's open a Rust project as an example:

```bash
cd ~/my-rust-project
NVIM_APPNAME=nvim.claude nvim
```

### 1. Find a file

Press `<Space>ff` (that's space, then f, then f)

Type part of the filename (fuzzy search!)

Press Enter to open

### 2. Search for text

Press `<Space>fg`

Type what you're searching for

Press Enter to jump to result

### 3. Navigate code

Put cursor on a function name

Press `gd` to jump to its definition

Press `Ctrl-o` to jump back

### 4. Edit and run

Make some changes

Press `Ctrl-\` to open terminal

Run `cargo build` (or whatever command)

Press `Ctrl-\` again to close terminal

### 5. Git commit

Make changes

Press `<Space>gs` for git status

Press `-` on files to stage them

Press `cc` to commit

Write message, save with `:wq`

Done!

## Learning More

### Explore keybindings

Press `<Space>` and wait 500ms - Which-Key shows all available commands!

Or press `<Space>fk` to search all keymaps.

### Check what's installed

```
:Lazy           " Plugin manager
:Mason          " Language servers
:checkhealth    " System health check
```

### Read the docs

Everything is documented:
- `README.md` - Full documentation
- Each plugin file has extensive comments
- `:help` for Neovim's built-in help

## Troubleshooting

### Plugins didn't install

Run `:Lazy` and press `I` to install, or `U` to update.

### Language server not working

1. Open a file in that language (e.g., `main.rs` for Rust)
2. Wait for server to install (watch bottom-right corner)
3. Run `:LspInfo` to check status
4. Run `:Mason` to manually install if needed

### Something looks wrong

Run `:checkhealth` to diagnose issues.

### Config is slow

Run `nvim --startuptime startup.log` and check the log.

Most common issue: too many plugins loading at startup. All plugins in this config use lazy loading!

## Next Steps

Once you're comfortable with the basics:

1. **Customize your colorscheme**
   - Edit `lua/plugins/colorscheme.lua`
   - Try alternatives (commented out in the file)

2. **Learn more keybindings**
   - Read `lua/config/keymaps.lua`
   - Press `<Space>` to see what's available

3. **Add more language support**
   - Edit `lua/plugins/lsp.lua`
   - Add your language server to the `servers` table

4. **Explore plugins**
   - Each file in `lua/plugins/` is one plugin
   - Read the comments to understand what it does
   - Remove what you don't need

5. **Make it yours**
   - Change options in `lua/config/options.lua`
   - Add keymaps in `lua/config/keymaps.lua`
   - Every choice is explained - modify freely!

## Cheat Sheet

Keep this handy for your first week:

### Files & Navigation
- `<Space>ff` - Find files
- `<Space>fg` - Find in files
- `<Space>fb` - Find buffers
- `<Space>fh` - Find help
- `<Tab>` / `<Shift-Tab>` - Next/prev buffer

### LSP (Code Intelligence)
- `gd` - Go to definition
- `gr` - Find references
- `K` - Show documentation
- `<Space>ca` - Code actions
- `<Space>rn` - Rename symbol

### Editing
- `gcc` - Toggle comment
- `Ctrl-/` - Toggle comment (alt)
- `Ctrl-Space` - Incremental selection
- `<Space>u` - Undo tree

### Git
- `<Space>gs` - Git status
- `<Space>gc` - Git commit
- `]c` / `[c` - Next/prev change
- `<Space>hp` - Preview change

### Terminal
- `Ctrl-\` - Toggle terminal
- `<Space>tf` - Floating terminal
- `Esc Esc` - Exit terminal mode

### Help
- `<Space>fk` - Find keymaps
- `<Space>fh` - Find help
- `:help <topic>` - Vim help

## Philosophy

This config is designed to be:

1. **Understood** - Every choice is documented
2. **Modified** - Change anything you want
3. **Learned from** - Read the code to understand Neovim

Don't just use it - study it! Understanding your tools makes you a better developer.

## Getting Help

1. Read the comments in config files
2. Check `:help <topic>`
3. Run `:checkhealth`
4. Search issues: most questions have been asked before
5. Ask in Neovim communities (Reddit, Discord, etc.)

## Welcome!

You're now using a professional, maintainable Neovim setup. Take your time learning it, and enjoy the journey from copy-pasting configs to truly understanding your editor.

Happy coding! 🚀
