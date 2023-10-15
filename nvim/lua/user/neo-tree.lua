-- https://github.com/nvim-neo-tree/neo-tree.nvim

local M = {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  commit = "2d89ca96e08eb6e9c8e50e1bb4738bc5125c9f12",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    -- {
    --   "s1n7ax/nvim-window-picker",
    --   config = function()
    --     require("window-picker").setup {
    --       hint = 'statusline-winbar',
    --       show_prompt = false,
    --       include_current = false,
    --       filter_rules = {
    --         autoselect_one = true,
    --         -- filter using buffer options
    --         bo = {
    --           -- if the file type is one of following, the window will be ignored
    --           filetype = { "neo-tree", "neo-tree-popup", "notify" },
    --
    --           -- if the buffer type is one of following, the window will be ignored
    --           buftype = { "terminal", "quickfix" },
    --         },
    --       },
    --     }
    --   end,
    -- },
  },
}

function M.config()
  local opts = {
    auto_clean_after_session_restore = true,
    close_if_last_window = false,
    sources = { "filesystem" },
    default_source = "filesystem",
    default_component_configs = {
      indent = { padding = 0 },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        folder_empty_open = "",
        default = "",
      },
      git_status = {
        symbols = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          untracked = "?",
          deleted = "",
          ignored = "◌",
          conflict = "",
        },
      },
      -- diagnostics = {
      --   enable = true,
      --   show_on_dirs = true,
      --   icons = {
      --     hint = "󰌵",
      --     info = "",
      --     warning = "",
      --     error = "",
      --   },
      -- },
    },
    commands = {
      parent_or_close = function(state)
        local node = state.tree:get_node()
        if (node.type == "directory" or node:has_children()) and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,
      child_or_open = function(state)
        local node = state.tree:get_node()
        if node.type == "directory" or node:has_children() then
          if not node:is_expanded() then -- if unexpanded, expand
            state.commands.toggle_node(state)
          else -- if expanded and has children, seleect the next child
            require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
          end
        else -- if not a directory just open it
          state.commands.open(state)
        end
      end,
      copy_selector = function(state)
        local node = state.tree:get_node()
        local filepath = node:get_id()
        local filename = node.name
        local modify = vim.fn.fnamemodify

        local vals = {
          ["BASENAME"] = modify(filename, ":r"),
          ["EXTENSION"] = modify(filename, ":e"),
          ["FILENAME"] = filename,
          ["PATH (CWD)"] = modify(filepath, ":."),
          ["PATH (HOME)"] = modify(filepath, ":~"),
          ["PATH"] = filepath,
          ["URI"] = vim.uri_from_fname(filepath),
        }

        local options = vim.tbl_filter(function(val)
          return vals[val] ~= ""
        end, vim.tbl_keys(vals))
        if vim.tbl_isempty(options) then
          return
        end
        table.sort(options)
        vim.ui.select(options, {
          prompt = "Choose to copy to clipboard:",
          format_item = function(item)
            return ("%s: %s"):format(item, vals[item])
          end,
        }, function(choice)
          local result = vals[choice]
          if result then
            vim.fn.setreg("+", result)
          end
        end)
      end,
      find_in_dir = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require("telescope.builtin").find_files {
          cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h"),
        }
      end,
      system_open = function(state)
        vim.ui.open(state.tree:get_node():get_id())
      end,
    },
    window = {
      width = 30,
      mappings = {
        ["<space>"] = false, -- disable space until we figure out which-key disabling
        ["[b"] = "prev_source",
        ["]b"] = "next_source",
        ["F"] = "find_in_dir" or nil,
        ["O"] = "system_open",
        ["Y"] = "copy_selector",
        ["h"] = "parent_or_close",
        ["l"] = "child_or_open",
        ["<cr>"] = "open",
        ["<C-x>"] = "open_split",
        ["<C-v>"] = "open_vsplit",
      },
      fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
        ["<C-j>"] = "move_cursor_down",
        ["<C-k>"] = "move_cursor_up",
      },
    },
    filesystem = {
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "open_current",
      use_libuv_file_watcher = true,
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(_)
          vim.opt_local.signcolumn = "auto"
        end,
      },
    },
  }

  require("neo-tree").setup(opts)
end

return M
