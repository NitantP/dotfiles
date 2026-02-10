--[[
  Vim Options (Settings)

  These are Neovim's settings - they control how the editor behaves.
  Each option is explained so you know what it does and why it's set.

  Format: vim.opt.option_name = value
  You can see all options with :help options
--]]

local opt = vim.opt

-- ============================================================================
-- DISPLAY
-- ============================================================================

-- Use 24-bit RGB colors (makes colors look better in terminal)
opt.termguicolors = true

-- Always show sign column (left gutter) to prevent text shifting when diagnostics appear
opt.signcolumn = "yes"

-- Don't show mode (-- INSERT --) in command line, status line shows it instead
opt.showmode = false

-- Keep 8 lines visible above/below cursor when scrolling (context)
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Show some invisible characters (helps with whitespace issues)
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Highlight the line the cursor is on (easier to find cursor)
opt.cursorline = true

-- ============================================================================
-- LINE NUMBERS
-- ============================================================================

-- Show absolute line number on cursor line
opt.number = true

-- Show relative line numbers (easier for motions like 5j, 10k)
opt.relativenumber = true

-- ============================================================================
-- INDENTATION
-- ============================================================================

-- Number of spaces a <Tab> counts for
opt.tabstop = 2

-- Number of spaces for each indent level (>>, <<, auto-indent)
opt.shiftwidth = 2

-- Convert tabs to spaces (more consistent across editors)
opt.expandtab = true

-- Copy indent from current line when starting new line
opt.autoindent = true

-- Smart indenting (indent after {, outdent after }, etc.)
opt.smartindent = true

-- ============================================================================
-- SEARCH
-- ============================================================================

-- Ignore case in search patterns
opt.ignorecase = true

-- Override ignorecase if search has uppercase (smart!)
opt.smartcase = true

-- Highlight all matches while searching
opt.hlsearch = true

-- Show matches as you type (incremental search)
opt.incsearch = true

-- ============================================================================
-- SPLITS
-- ============================================================================

-- Open horizontal splits below current window (more natural)
opt.splitbelow = true

-- Open vertical splits to right of current window (more natural)
opt.splitright = true

-- ============================================================================
-- EDITING
-- ============================================================================

-- Don't wrap long lines (prevents confusion, use gj/gk if needed)
opt.wrap = false

-- Allow backspace over indent, line breaks, and insert start
opt.backspace = "indent,eol,start"

-- Enable mouse support in all modes (useful for resizing splits, clicking)
opt.mouse = "a"

-- Use system clipboard for yank/paste (y and p work with Ctrl-C/Ctrl-V)
opt.clipboard = "unnamedplus"

-- ============================================================================
-- FILES & PERSISTENCE
-- ============================================================================

-- Save undo history to file (undo persists after closing file!)
opt.undofile = true

-- Don't create backup files (most people use git now)
opt.backup = false
opt.writebackup = false

-- Don't create swap files (causes more confusion than it helps)
opt.swapfile = false

-- ============================================================================
-- PERFORMANCE
-- ============================================================================

-- Faster completion (default is 4000ms = 4s, too slow)
opt.updatetime = 250

-- Time to wait for mapped sequence (default is 1000ms)
opt.timeoutlen = 300

-- ============================================================================
-- COMMAND LINE
-- ============================================================================

-- Show preview of commands like :s/foo/bar in split window
opt.inccommand = "split"

-- Better command-line completion
opt.wildmode = "longest:full,full"

-- ============================================================================
-- FOLDING (code folding, collapse functions/blocks)
-- ============================================================================

-- Use Treesitter for folding (smarter than indent-based)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Start with all folds open (don't want files opening all collapsed)
opt.foldlevel = 99
opt.foldlevelstart = 99

-- ============================================================================
-- FILE BROWSER (netrw - built-in file explorer)
-- ============================================================================

-- Use tree-style listing in netrw (if you use it)
vim.g.netrw_liststyle = 3

-- ============================================================================
-- TIPS
-- ============================================================================

--[[
  HOW TO CUSTOMIZE:

  1. Find the option you want to change in this file
  2. Modify the value
  3. Save and restart Neovim (or :source % to reload)

  COMMON CUSTOMIZATIONS:

  - Change tab width to 4 spaces:
    opt.tabstop = 4
    opt.shiftwidth = 4

  - Enable line wrapping:
    opt.wrap = true

  - Disable relative numbers:
    opt.relativenumber = false

  - Change scroll offset:
    opt.scrolloff = 3

  You can check any option's current value with:
    :set option?

  Example: :set tabstop?
--]]
