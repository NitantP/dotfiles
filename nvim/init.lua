--[[
  Neovim Configuration Entry Point

  This file is the first thing Neovim loads. It sets up the configuration in order:
  1. Bootstrap lazy.nvim (plugin manager)
  2. Load vim options (settings)
  3. Load keymaps (keyboard shortcuts)
  4. Load plugins (lazy.nvim handles this automatically)

  Everything is modular - each piece lives in its own file under lua/
--]]

-- Set leader key BEFORE lazy.nvim loads
-- Leader is used as a prefix for custom commands (like <space>ff for find files)
-- Must be set before plugins load so they can use it
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim (installs it if not present)
require("config.lazy")

-- Load core configuration
require("config.options")  -- Vim settings (line numbers, tabs, etc.)
require("config.keymaps")  -- Keyboard shortcuts

-- Plugins are loaded automatically by lazy.nvim from lua/plugins/
-- Any .lua file in lua/plugins/ will be automatically loaded
