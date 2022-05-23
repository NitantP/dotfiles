function nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.api.nvim_command('augroup ' .. group_name)
        vim.api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten({ 'autocmd', def }), ' ')
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command('augroup END')
    end
end

local autocmds = {
    inlay_hints = {
        { 'CursorHold,CursorHoldI', '*.rs', ":lua require'lsp_extensions'.inlay_hints{ only_current_line = false }" },
    },
}

nvim_create_augroups(autocmds)
