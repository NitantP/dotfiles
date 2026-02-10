--[[
  lazy.nvim Bootstrap

  This file:
  1. Installs lazy.nvim if it's not already installed (auto-setup)
  2. Configures lazy.nvim to load all plugins from lua/plugins/

  lazy.nvim is a modern plugin manager that:
  - Only loads plugins when needed (lazy loading = fast startup)
  - Handles installation and updates automatically
  - Has a nice UI (:Lazy)
--]]

-- Path where lazy.nvim will be installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is installed, if not, clone it from GitHub
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",  -- Faster clone, downloads only what's needed
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",  -- Use stable release, not main branch
    lazypath,
  })
end

-- Add lazy.nvim to Neovim's runtime path so we can require() it
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim to load all plugins
require("lazy").setup({
  -- Automatically import all .lua files from lua/plugins/
  { import = "plugins" },
}, {
  -- Configuration for lazy.nvim itself
  checker = {
    enabled = true,   -- Automatically check for plugin updates
    notify = false,   -- Don't show notifications (can be annoying)
  },
  change_detection = {
    notify = false,   -- Don't notify when config files change
  },
  performance = {
    rtp = {
      -- Disable some built-in plugins we don't need for faster startup
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
