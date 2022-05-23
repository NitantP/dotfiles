-- Automatically install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = vim.fn.system {
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
    }
    print 'Installing Packer...'
end

-- Reload Neovim whenever this file is saved
vim.cmd [[
    augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

-- Initialize Packer (using a protected call for error handling)
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
    return
end

-- Display Packer in a floating window
packer.init {
    display = {
        open_fn = function ()
            return require('packer.util').float { border = 'rounded' }
        end,
    },
}

-- Define plugins
return packer.startup(function(use)
    -- Bootstrap Packer
    use 'wbthomason/packer.nvim'

    -- Misc
    use 'tpope/vim-surround'
    use {
        'preservim/vimux',
        config = require('user.vimux'),
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    use 'antoinemadec/FixCursorHold.nvim'

    -- Theme
    use 'Luxed/ayu-vim'

    -- Files
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use {
        'nvim-telescope/telescope.nvim',
        config = require('user.telescope'),
    }
    use 'tpope/vim-vinegar'

    -- Git
    use 'lewis6991/gitsigns.nvim'

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        config = require('user.lspconfig'),
    }
    use 'nvim-lua/lsp_extensions.nvim'
    use { 'hrsh7th/cmp-nvim-lsp', branch = 'main' }
    use { 'hrsh7th/cmp-buffer', branch = 'main' }
    use { 'hrsh7th/cmp-path', branch = 'main' }
    use {
        'hrsh7th/nvim-cmp',
        branch = 'main',
        config = require('user.cmp'),
    }
    use 'ray-x/lsp_signature.nvim'

    -- | Snippets
    use { 'hrsh7th/cmp-vsnip', branch = 'main' }
    use 'hrsh7th/vim-vsnip'

    -- Languages
    -- | TOML
    use 'cespare/vim-toml'
    
    -- | YAML
    use 'stephpy/vim-yaml'
    
    -- | rust
    use 'rust-lang/rust.vim'

    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)
