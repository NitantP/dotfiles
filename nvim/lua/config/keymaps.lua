--[[
  Keymaps (Keyboard Shortcuts)

  These are custom keyboard shortcuts that make Neovim easier to use.
  Format: vim.keymap.set(mode, key, action, { desc = "Description" })

  Modes:
    "n" = normal mode
    "i" = insert mode
    "v" = visual mode
    "x" = visual mode (without select mode)
    "" = normal, visual, and operator-pending modes

  The desc field makes the keymap searchable with Telescope (<leader>fk)
--]]

local keymap = vim.keymap.set

-- ============================================================================
-- ESSENTIAL
-- ============================================================================

-- Clear search highlights (after searching with /)
-- Press Esc to clear the yellow highlighting
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Save file with Ctrl-S (works in normal and insert mode)
-- Muscle memory from every other editor
keymap({ "n", "i" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- Quit file
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- ============================================================================
-- WINDOW NAVIGATION
-- ============================================================================

-- Move between splits with Ctrl + hjkl (no need for Ctrl-W first)
-- Much faster than the default Ctrl-W h/j/k/l
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

-- Resize splits with Ctrl + arrow keys
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- ============================================================================
-- BUFFER NAVIGATION
-- ============================================================================

-- Switch between buffers with Tab and Shift-Tab
-- Buffers are like tabs in other editors
keymap("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Close current buffer
keymap("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- ============================================================================
-- SCROLLING
-- ============================================================================

-- Center cursor after half-page jumps (easier to track where you are)
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half-page (centered)" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half-page (centered)" })

-- Center cursor when jumping through search results
keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- ============================================================================
-- EDITING
-- ============================================================================

-- Keep visual selection when indenting (so you can indent multiple times)
keymap("v", "<", "<gv", { desc = "Indent left (keep selection)" })
keymap("v", ">", ">gv", { desc = "Indent right (keep selection)" })

-- Move selected lines up/down in visual mode (like Alt+Up/Down in VS Code)
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Don't yank when pasting over selection (paste multiple times without losing)
keymap("v", "p", '"_dP', { desc = "Paste without yanking" })

-- ============================================================================
-- SPLITS
-- ============================================================================

-- Create splits
keymap("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
keymap("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- ============================================================================
-- DIAGNOSTICS (LSP errors/warnings)
-- ============================================================================

-- Navigate between diagnostics (errors, warnings)
-- These will be enhanced by LSP when it loads
keymap("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
keymap("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
keymap("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- ============================================================================
-- QUICKFIX / LOCATION LIST
-- ============================================================================

-- Navigate quickfix list (used by grep, make, etc.)
keymap("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })
keymap("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
keymap("n", "<leader>co", "<cmd>copen<CR>", { desc = "Open quickfix list" })
keymap("n", "<leader>cc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })

-- ============================================================================
-- TERMINAL
-- ============================================================================

-- Exit terminal mode with Esc (instead of Ctrl-\ Ctrl-N)
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ============================================================================
-- TIPS
-- ============================================================================

--[[
  HOW TO ADD YOUR OWN KEYMAPS:

  1. Choose a key combination (check it's not used: run the key in normal mode)
  2. Add a line like:
     keymap("n", "<leader>x", "<cmd>command<CR>", { desc = "What it does" })

  EXAMPLES:

  - Map <leader>w to save:
    keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

  - Map <leader>e to open file explorer:
    keymap("n", "<leader>e", vim.cmd.Ex, { desc = "Open file explorer" })

  - Map <leader>/ to toggle comment (requires comment plugin):
    keymap("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })

  FINDING EXISTING KEYMAPS:

  - See all keymaps: :map
  - See normal mode keymaps: :nmap
  - See what a key does: :nmap <key>
  - Search keymaps with Telescope: <leader>fk (once telescope is loaded)

  LEADER KEY:

  Leader is space (set in init.lua).
  Leader-based keymaps are great because:
  - Space is easy to reach
  - Space doesn't conflict with Vim's default keys
  - You can organize keymaps by category (f = find, g = git, etc.)
--]]
