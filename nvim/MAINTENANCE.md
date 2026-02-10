# Maintenance Guide

How to keep your Neovim config healthy and up-to-date.

## Regular Maintenance

### Update Plugins (Monthly)

```vim
:Lazy update
```

This updates all plugins to their latest versions.

**After updating:**
1. Restart Neovim
2. Check for errors: `:messages`
3. Run `:checkhealth` to verify everything works

### Update Language Servers (As Needed)

```vim
:Mason
```

Press `U` to update all servers.

Or update specific servers:
```vim
:MasonUpdate rust-analyzer
```

### Check for Issues (When Something Seems Wrong)

```vim
:checkhealth
```

This runs diagnostics on your entire setup and reports issues.

## Common Maintenance Tasks

### Plugin Breaking After Update?

1. Check the plugin's changelog (often on GitHub)
2. Look for breaking changes in configuration
3. Temporarily pin to older version:

```lua
{
  "username/plugin",
  commit = "abc123",  -- Pin to specific commit
}
```

Find the commit hash on GitHub, or use `:Lazy log` to see versions.

### LSP Server Not Working After Update?

1. Reinstall the server:
   ```vim
   :MasonUninstall rust-analyzer
   :MasonInstall rust-analyzer
   ```

2. Check LSP logs:
   ```vim
   :LspLog
   ```

3. Restart LSP:
   ```vim
   :LspRestart
   ```

### Neovim Startup Getting Slow?

1. Check startup time:
   ```bash
   nvim --startuptime startup.log
   ```

2. Look for plugins loading early (not lazy-loaded)

3. Add lazy-loading to slow plugins:
   ```lua
   {
     "username/plugin",
     event = "VeryLazy",  -- or cmd, ft, keys, etc.
   }
   ```

### Configuration File Changed But Nothing Happened?

Neovim caches Lua files. After editing config:

1. Restart Neovim (most reliable)
2. Or reload config:
   ```vim
   :source $MYVIMRC
   :Lazy reload plugin-name
   ```

## Troubleshooting Guide

### Problem: "Module not found" error

**Cause:** Plugin not installed or file in wrong location

**Fix:**
```vim
:Lazy sync
```

### Problem: LSP not attaching

**Symptoms:** No completions, no diagnostics, `:LspInfo` shows "0 clients attached"

**Fix:**
1. Check LSP is installed:
   ```vim
   :Mason
   ```

2. Check language server is configured:
   ```vim
   :LspInfo
   ```

3. Make sure file type is correct:
   ```vim
   :set filetype?
   ```

4. Restart LSP:
   ```vim
   :LspRestart
   ```

### Problem: Completions not showing

**Fix:**
1. Check nvim-cmp is loaded:
   ```vim
   :Lazy load nvim-cmp
   ```

2. Check completion sources:
   ```vim
   :CmpStatus
   ```

3. Manually trigger completion:
   ```
   Ctrl-Space
   ```

### Problem: Keybindings not working

**Fix:**
1. Check keybinding is set:
   ```vim
   :map <keymap>
   ```

2. Search all keymaps:
   ```
   <leader>fk
   ```

3. Check for conflicts:
   ```vim
   :verbose map <keymap>
   ```

### Problem: Colors look wrong

**Symptoms:** Weird colors, black text on black background, etc.

**Fix:**
1. Check terminal supports true color:
   ```bash
   echo $COLORTERM  # Should show "truecolor" or "24bit"
   ```

2. Add to shell config (`~/.bashrc` or `~/.zshrc`):
   ```bash
   export COLORTERM=truecolor
   ```

3. Restart terminal

### Problem: Undo history not persisting

**Fix:**
Check undo directory exists:
```bash
mkdir -p ~/.local/share/nvim/undo
```

Or check option is set:
```vim
:set undofile?
```

### Problem: Git signs not showing

**Fix:**
1. Make sure you're in a git repository:
   ```bash
   git status
   ```

2. Toggle gitsigns:
   ```vim
   :Gitsigns toggle_signs
   ```

### Problem: Telescope not finding files

**Fix:**
1. Check working directory:
   ```vim
   :pwd
   ```

2. Change directory if needed:
   ```vim
   :cd /path/to/project
   ```

3. Check file patterns:
   - Telescope respects `.gitignore` by default
   - Hidden files are shown (configured in telescope.lua)

## Cleaning Up

### Remove Unused Plugins

After deleting plugin file:
```vim
:Lazy clean
```

### Clear Plugin Cache

```bash
rm -rf ~/.local/share/nvim/lazy
```

Then restart Neovim (plugins will reinstall).

### Clear Language Server Cache

```bash
rm -rf ~/.local/share/nvim/mason
```

Then reinstall servers with `:Mason`.

### Nuclear Option: Fresh Start

```bash
# Backup your config
cp -r ~/.config/nvim ~/.config/nvim.backup

# Remove all Neovim data
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Restart Neovim (everything will reinstall)
nvim
```

## Best Practices

### 1. Version Control Your Config

```bash
cd ~/.config/nvim
git init
git add .
git commit -m "Initial commit"
```

Benefits:
- Track changes
- Revert breaking changes
- Sync across machines

### 2. Test Changes in Isolation

Before making big changes:
```bash
cp -r ~/.config/nvim ~/.config/nvim.test
NVIM_APPNAME=nvim.test nvim
```

### 3. Document Your Changes

Add comments to config files:
```lua
-- Added 2024-01-29: Support for Go language
gopls = {},
```

### 4. Keep a Changelog

Create `CHANGELOG.md`:
```markdown
## 2024-01-29
- Added Go language support
- Changed colorscheme to gruvbox
- Removed neo-tree (using netrw instead)
```

### 5. Update Regularly But Carefully

- Update plugins monthly (not daily)
- Read changelogs before updating
- Test after updating
- Keep backup of working config

### 6. Don't Blindly Copy

When you see a cool plugin/config online:
- Read what it does
- Check if you actually need it
- Understand the code before adding
- Test it first

## Monitoring Health

### Weekly Check

```vim
:checkhealth
```

Look for warnings or errors.

### Monthly Review

1. `:Lazy` - Update plugins
2. `:Mason` - Update language servers
3. `nvim --startuptime startup.log` - Check startup time
4. Review which plugins you actually use

### Signs Your Config Needs Attention

- [ ] Neovim takes >500ms to start
- [ ] Frequent error messages
- [ ] LSP often crashes or disconnects
- [ ] Plugins not working as expected
- [ ] Keybindings forgotten (too many/complex)

## Getting Help

### 1. Check Health

Always start with:
```vim
:checkhealth
```

### 2. Check Messages

See all messages:
```vim
:messages
```

### 3. Check Logs

Plugin logs:
```vim
:Lazy log
```

LSP logs:
```vim
:LspLog
```

### 4. Search Issues

Most problems have been solved:
- Plugin GitHub issues
- Neovim GitHub discussions
- Reddit r/neovim

### 5. Ask for Help

When asking for help, include:
1. Neovim version: `nvim --version`
2. Error message from `:messages`
3. Output of `:checkhealth`
4. Minimal reproducible config

## Backup Strategy

### What to Backup

**Must backup:**
- `~/.config/nvim/` - Your configuration

**Optional:**
- `~/.local/share/nvim/` - Plugin data, undo history
- `~/.local/state/nvim/` - Session data

### How to Backup

Simple:
```bash
tar -czf nvim-backup-$(date +%Y%m%d).tar.gz ~/.config/nvim
```

With version control:
```bash
cd ~/.config/nvim
git init
git add .
git commit -m "Backup $(date)"
git remote add origin <your-repo>
git push
```

### Restore from Backup

```bash
tar -xzf nvim-backup-20240129.tar.gz -C ~/
```

Or with git:
```bash
cd ~/.config/nvim
git reset --hard HEAD
```

## Migration Guide

### When Neovim Updates

1. Check release notes: https://github.com/neovim/neovim/releases
2. Look for breaking changes
3. Update Neovim:
   ```bash
   # macOS
   brew upgrade neovim

   # Linux (from source or package manager)
   ```
4. Restart and check health:
   ```vim
   :checkhealth
   ```

### When Lua API Changes

If plugins break after Neovim update:

1. Update all plugins:
   ```vim
   :Lazy update
   ```

2. Check plugin issues on GitHub

3. Temporarily downgrade Neovim if needed

## Performance Tuning

### Measure First

```bash
nvim --startuptime startup.log
```

Look for:
- Total time (should be <200ms)
- Slow plugins (>50ms)

### Common Fixes

1. **Lazy-load plugins:**
   ```lua
   event = "VeryLazy"  -- Load after startup
   ft = "rust"        -- Load for specific filetype
   cmd = "Command"    -- Load when command is used
   ```

2. **Disable unused plugins:**
   Delete plugin file or add:
   ```lua
   enabled = false
   ```

3. **Reduce treesitter parsers:**
   Only install languages you use

4. **Disable animations:**
   Comment out neoscroll plugin

### Target Times

- Startup: <200ms
- First file open: <1s
- LSP attach: <2s

## Summary

Keep your config:
- **Updated** - Monthly plugin updates
- **Clean** - Remove unused plugins
- **Documented** - Comment your changes
- **Backed up** - Version control or archives
- **Tested** - Check health regularly

Your config is a living document. Maintain it, and it will serve you well!
