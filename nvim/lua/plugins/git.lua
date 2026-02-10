--[[
  Git Integration

  Three plugins:
  1. Gitsigns: Shows git changes in gutter (added/modified/removed lines)
  2. Fugitive: Full git interface inside Neovim
  3. Diffview: Advanced diff viewer and file history

  Why all three?
  - Gitsigns: Passive, always-on visual feedback
  - Fugitive: Active, when you need to commit/push/etc.
  - Diffview: When you need to review changes or file history
--]]

return {
  -- Gitsigns: Git decorations in gutter
  {
    "lewis6991/gitsigns.nvim",

    -- Load only in git repositories
    event = { "BufReadPre", "BufNewFile" },

    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" }, -- Line was added
          change = { text = "│" }, -- Line was changed
          delete = { text = "_" }, -- Line was deleted
          topdelete = { text = "‾" }, -- Line was deleted at top
          changedelete = { text = "~" }, -- Line was changed and deleted
        },

        -- Show blame info inline (who wrote this line)
        current_line_blame = false, -- Set to true to enable (can be noisy)
        current_line_blame_opts = {
          delay = 500,              -- Show after 500ms
        },

        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Helper for keymaps
          local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          -- Navigation between hunks (changes)
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Next git hunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Previous git hunk" })

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Stage selected hunk" })
          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Reset selected hunk" })

          map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })

          -- Blame
          map("n", "<leader>hb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame line" })
          map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })

          -- Diff
          map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
        end,
      })
    end,
  },

  -- Fugitive: Full git interface
  {
    "tpope/vim-fugitive",

    -- Load only when git commands are used
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gwrite", "Gread" },

    keys = {
      { "<leader>gs", "<cmd>Git<cr>",        desc = "Git status" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Git push<cr>",   desc = "Git push" },
      { "<leader>gl", "<cmd>Git pull<cr>",   desc = "Git pull" },
      { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff split" },
      { "<leader>gb", "<cmd>Git blame<cr>",  desc = "Git blame" },
    },
  },

  -- Optional: Better commit message editing
  {
    "rhysd/committia.vim",
    event = "BufReadPre COMMIT_EDITMSG",
  },

  -- Diffview: Advanced diff viewer and file history
  {
    "sindrets/diffview.nvim",

    dependencies = { "nvim-lua/plenary.nvim" },

    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },

    keys = {
      { "<leader>dv", "<cmd>DiffviewOpen<cr>",          desc = "Open diff view" },
      { "<leader>dc", "<cmd>DiffviewClose<cr>",         desc = "Close diff view" },
      { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
      { "<leader>dH", "<cmd>DiffviewFileHistory<cr>",   desc = "File history (all files)" },
      { "<leader>dm", "<cmd>DiffviewOpen HEAD~1<cr>",   desc = "Diff with previous commit" },
    },

    config = function()
      require("diffview").setup({
        diff_binaries = false,   -- Show diffs for binaries
        enhanced_diff_hl = true, -- Better syntax highlighting in diffs
        use_icons = true,        -- Requires a Nerd Font

        -- File panel configuration
        file_panel = {
          listing_style = "tree",            -- 'list' or 'tree'
          tree_options = {
            flatten_dirs = true,             -- Flatten single-child directories
            folder_statuses = "only_folded", -- 'never', 'only_folded', 'always'
          },
          win_config = {
            position = "left",
            width = 35,
          },
        },

        -- File history panel configuration
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = "combined", -- 'combined', 'first-parent'
              },
              multi_file = {
                diff_merges = "first-parent",
              },
            },
          },
          win_config = {
            position = "bottom",
            height = 16,
          },
        },

        -- Keymaps in diffview buffers
        keymaps = {
          view = {
            -- Keymaps in diff view
            { "n", "<tab>", "<cmd>DiffviewToggleFiles<cr>",                                    { desc = "Toggle file panel" } },
            { "n", "q",     "<cmd>DiffviewClose<cr>",                                          { desc = "Close diffview" } },
            { "n", "[c",    "<cmd>lua require('diffview.config').actions.prev_conflict()<cr>", { desc = "Previous conflict" } },
            { "n", "]c",    "<cmd>lua require('diffview.config').actions.next_conflict()<cr>", { desc = "Next conflict" } },
          },
          file_panel = {
            -- Keymaps in file panel
            { "n", "j",     "<cmd>lua require('diffview.config').actions.next_entry()<cr>",   { desc = "Next file" } },
            { "n", "k",     "<cmd>lua require('diffview.config').actions.prev_entry()<cr>",   { desc = "Previous file" } },
            { "n", "<cr>",  "<cmd>lua require('diffview.config').actions.select_entry()<cr>", { desc = "Open diff" } },
            { "n", "o",     "<cmd>lua require('diffview.config').actions.select_entry()<cr>", { desc = "Open diff" } },
            { "n", "<tab>", "<cmd>DiffviewToggleFiles<cr>",                                   { desc = "Toggle file panel" } },
            { "n", "q",     "<cmd>DiffviewClose<cr>",                                         { desc = "Close diffview" } },
          },
          file_history_panel = {
            -- Keymaps in file history panel
            { "n", "j",    "<cmd>lua require('diffview.config').actions.next_entry()<cr>",   { desc = "Next commit" } },
            { "n", "k",    "<cmd>lua require('diffview.config').actions.prev_entry()<cr>",   { desc = "Previous commit" } },
            { "n", "<cr>", "<cmd>lua require('diffview.config').actions.select_entry()<cr>", { desc = "Open commit" } },
            { "n", "o",    "<cmd>lua require('diffview.config').actions.select_entry()<cr>", { desc = "Open commit" } },
            { "n", "q",    "<cmd>DiffviewClose<cr>",                                         { desc = "Close file history" } },
          },
        },
      })
    end,
  },
}

--[[
  GIT USAGE:

  GITSIGNS (VISUAL FEEDBACK):

  Gutter signs:
  │  - Line added or changed
  _  - Line deleted

  Keymaps:
  ]c         - Jump to next change (hunk)
  [c         - Jump to previous change
  <leader>hp - Preview hunk (see what changed)
  <leader>hs - Stage hunk (git add this change)
  <leader>hr - Reset hunk (undo this change)
  <leader>hb - Show who wrote this line (blame)
  <leader>tb - Toggle inline blame

  FUGITIVE (GIT COMMANDS):

  Basic workflow:
  1. <leader>gs - Open git status
  2. Stage files: move cursor to file, press `-` to stage/unstage
  3. <leader>gc - Commit (write message, :wq to save)
  4. <leader>gp - Push to remote

  Git status window:
  -       - Stage/unstage file under cursor
  =       - Toggle inline diff
  Enter   - Open file or diff
  dv      - Diff split (visual diff)
  cc      - Create commit
  ca      - Amend commit

  Other commands:
  :G <command>        - Run any git command
  :G log              - Git log
  :G blame            - Git blame
  :Gdiffsplit         - Diff current file
  :Gwrite             - Stage current file
  :Gread              - Checkout current file (undo changes)

  WORKFLOW EXAMPLES:

  Quick commit:
  1. <leader>gs
  2. Stage files with `-`
  3. Press `cc` to commit
  4. Write message, save (:wq)
  5. <leader>gp to push

  Check what changed:
  1. <leader>hp to preview current change
  2. <leader>gd to see full file diff

  Undo local changes:
  1. <leader>gs
  2. Move to file
  3. Type `X` to discard changes

  TIPS:

  - Gitsigns works automatically (no commands needed)
  - Fugitive is modal (like vim) - navigate with hjkl
  - Use `:G <command>` for any git operation
  - Press `g?` in fugitive status for help

  DIFFVIEW (ADVANCED DIFF VIEWER):

  Basic commands:
  <leader>dv  - Open diff view (see all changes)
  <leader>dc  - Close diff view
  <leader>dh  - File history for current file
  <leader>dH  - File history for entire project
  <leader>dm  - Diff with previous commit

  In diff view:
  Tab      - Toggle file panel
  ]c       - Next conflict (in merge conflicts)
  [c       - Previous conflict
  q        - Quit diff view

  In file panel:
  j/k      - Navigate files
  Enter/o  - Open file diff
  Tab      - Toggle panel
  q        - Close

  Advanced usage:
  :DiffviewOpen                     - All uncommitted changes
  :DiffviewOpen HEAD~2              - Changes from 2 commits ago
  :DiffviewOpen main                - Diff with main branch
  :DiffviewOpen main..feature       - Compare branches
  :DiffviewFileHistory              - All commits for all files
  :DiffviewFileHistory %            - All commits for current file
  :DiffviewFileHistory --range=main - Commits since main

  Use cases:

  Review all changes before commit:
  1. Make changes to multiple files
  2. <leader>dv to open diff view
  3. Navigate with j/k, review each file
  4. q to close
  5. Proceed with commit

  View file history:
  1. Open file you want to investigate
  2. <leader>dh to see all commits that touched this file
  3. Navigate commits with j/k
  4. Press Enter to see that commit's diff
  5. q to close

  Compare branches:
  1. :DiffviewOpen main..feature
  2. See all differences between branches
  3. Review before merging

  Resolve merge conflicts:
  1. During merge conflict, <leader>dv
  2. See all conflicted files
  3. Use ]c and [c to jump between conflicts
  4. Edit to resolve, save
  5. q and proceed with merge

  TROUBLESHOOTING:

  Gitsigns not showing?
  - Make sure you're in a git repository
  - :Gitsigns toggle to restart

  Fugitive not working?
  - Make sure git is installed: `git --version`
  - Check you're in a git repo: `:G status`

  Diffview not opening?
  - Make sure you're in a git repository
  - Try :DiffviewOpen manually
  - Check :messages for errors

  TIPS:

  - Diffview is great for code review (review your own changes)
  - Use file history to understand when/why code changed
  - Combine with fugitive: review with diffview, commit with fugitive
  - Gitsigns for quick inline changes, diffview for full context
--]]
