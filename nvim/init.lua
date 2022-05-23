local config_modules = {
    'core.plugins',
    'core.settings',
    'core.keymappings',
    'core.autocmd',
}

for _, module in ipairs(config_modules) do
    local ok, err = pcall(require, module)
    if not ok then
        error('Error loading ' .. module .. '\n\n' .. err)
    end
end
