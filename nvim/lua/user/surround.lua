local M = {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
}

function M.config()
  local opts = {}

  require("nvim-surround").setup(opts)
end

return M
