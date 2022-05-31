local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
    return
end

local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok then
    return
end

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', ':lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<space>i', ':lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', ':lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>D', ':lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', ':lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>a', ':lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', ':lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', ':lua vim.diagnostic.open_float(0, { scope = "line",  border = "single" })<CR>', opts)
    buf_set_keymap('n', '[d', ':lua vim.diagnostic.goto_prev({ float = { border = "single" }})<CR>', opts)
    buf_set_keymap('n', ']d', ':lua vim.diagnostic.goto_next({ float = { border = "single" }})<CR>', opts)
    buf_set_keymap('n', '<space>q', ':lua vim.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap("n", "<space>f", ":lua vim.lsp.buf.format{ async = true }<CR>", opts)
end

lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
             },
            completion = {
                postfix = {
                    enable = false,
                },
            },
        },
    },
    capabilities = capabilities,
}
