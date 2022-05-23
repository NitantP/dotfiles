local config_path = os.getenv('MYVIMRC')

vim.g.mapleader = ' '

-- Navigation
vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', '$')
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-l>', '<Right>')
vim.keymap.set('i', '<C-k>', '<C-o>gk')
vim.keymap.set('i', '<C-j>', '<C-o>gj')

vim.keymap.set("n", "gl", "`.")

-- Open and source $MYVIMRC
vim.keymap.set('n', '<leader>ec', ':e' .. config_path .. '<CR>', { silent = true})
vim.keymap.set('n', '<leader>sc', ':source' .. config_path .. '<CR>', { silent = true})

-- Buffers and splits
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>')
vim.keymap.set('n', '<leader>bn', ':bnext<CR>')
vim.keymap.set('n', '<leader>b', ':ls<CR>:b<Space>')
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { silent = true })
vim.keymap.set('n', '<M-h>', '<C-w>h')
vim.keymap.set('n', '<M-j>', '<C-w>j')
vim.keymap.set('n', '<M-k>', '<C-w>k')
vim.keymap.set('n', '<M-l>', '<C-w>l')

-- Center search results
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })

-- Plugins
-- | Telescope
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>')
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>')
