local root = vim.fn.expand('~')

-- Undo history
vim.opt.undodir= root .. '/.vimdid/'
vim.opt.undofile = true

-- wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = { 'longest:list', 'full', }
vim.opt.wildignore:append {
    '.hg',
    '.svn',
    '*~',
    '*.png',
    '*.jpg',
    '*.gif',
    '*.settings',
    'Thumbs.db',
    '*.min.js',
    '*.swp',
    '*.o',
}

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

-- GUI
vim.opt.showcmd = true

-- diff
vim.opt.diffopt:append { 'iwhite', 'algorithm:patience', 'indent-heuristic', }

-- LSP
-- | Completion
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect', }

-- | Folding
vim.opt.foldmethod = 'syntax'

-- | rust
vim.g['rustfmt_autosave'] = 1
vim.g['rustfmt_emit_files'] = 1
vim.g['rustfmt_fail_silently'] = 0
vim.g['rust_clip_command'] = 'xclip -selection clipboard'
vim.g['rust_fold'] = 1

-- 300ms of no cursor movement to trigger CursorHold
vim.opt.updatetime = 300

vim.opt.ttyfast = true
vim.opt.cmdheight = 2
vim.opt.compatible = false
vim.opt.showmatch = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.nu = true
vim.opt.rnu = true

vim.cmd [[
    syntax on
    filetype plugin on
    filetype plugin indent on
]]

-- Statusline
vim.opt.laststatus = 2

local sl_buffer_number = '%1* %n %*'
local sl_full_path = '%4* %<%F%*' 
local sl_modified_flag = '%2*%m%*' 
local sl_current_line = '%1*%=%5l%*'
local sl_total_lines = '%2*/%L%*'
local sl_virtual_column_number = '%1*%4v %*'
local sl_character_under_cursor = '%2*0x%04B %*'
vim.opt.statusline =
    sl_buffer_number ..
    sl_full_path ..
    sl_modified_flag ..
    sl_current_line ..
    sl_total_lines ..
    sl_virtual_column_number ..
    sl_character_under_cursor

-- GUI
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.cmd [[ colorscheme ayu ]]

-- netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

-- LSP
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = "single",
    }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = "single",
    }
)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = true,
        update_in_insert = true,
        border = "single",
    }
)
