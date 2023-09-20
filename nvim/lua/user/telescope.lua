-- https://github.com/nvim-telescope/telescope.nvim

local M = {
  "nvim-telescope/telescope.nvim",
  commit = "a19770625aed49ad2a9f591a5e3946707f7359f6",
  event = "Bufenter",
  cmd = { "Telescope" },
}

function M.config()
  local ok, actions = pcall(require, "telescope.actions")
  if not ok then
    return
  end

  local opts = {
    defaults = {
      prompt_prefix = "? ",
      selection_caret = "> ",
      path_display = { "smart" },
      file_ignore_patterns = { ".git/", "node_modules" },
      mappings = {
        i = {
          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
      },
    },
  }

  require("telescope").setup(opts)
end

return M
