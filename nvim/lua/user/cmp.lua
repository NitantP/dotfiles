local M = {
  "hrsh7th/nvim-cmp",
  commit = "cfafe0a1ca8933f7b7968a287d39904156f2c57d",
  dependencies = {
    {
      "hrsh7th/cmp-nvim-lsp",
      commit = "0e6b2ed705ddcff9738ec4ea838141654f12eeef",
    },
    {
      "hrsh7th/cmp-buffer",
      commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
    },
    {
      "hrsh7th/cmp-path",
      commit = "91ff86cd9c29299a64f968ebb45846c485725f23",
    },
    {
      "hrsh7th/cmp-cmdline",
      commit = "23c51b2a3c00f6abc4e922dbd7c3b9aca6992063",
    },
    {
      "saadparwaiz1/cmp_luasnip",
      commit = "18095520391186d634a0045dacaa346291096566",
    },
    {
      "L3MON4D3/LuaSnip",
      commit = "9bff06b570df29434a88f9c6a9cea3b21ca17208",
      event = "InsertEnter",
      dependencies = {
        "rafamadriz/friendly-snippets",
        commit = "a6f7a1609addb4e57daa6bedc300f77f8d225ab7",
      },
    },
    {
      "hrsh7th/cmp-nvim-lua",
      commit = "f3491638d123cfd2c8048aefaf66d246ff250ca6",
    },
    {
      "onsails/lspkind.nvim",
    }
  },
  event = {
    "InsertEnter",
    "CmdlineEnter",
  },
}

function M.config()
  local cmp = require "cmp"
  local luasnip = require "luasnip"
  local lspkind = require "lspkind"
  require("luasnip/loaders/from_vscode").lazy_load()

  local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
  end

  vim.api.nvim_set_hl(0, "CmpItemKind", { fg = "#f8cd8c", bg = "NONE" })
  vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#f8c8dc", bg = "NONE" })
  -- vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#ffc300", bg = "NONE" })
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#ffc300", bg = "NONE" })
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#ffc300", bg = "NONE" })


  -- https://github.com/L3MON4D3/LuaSnip/issues/656#issuecomment-1500869758
  -- avoid incomplete snippet causing <Tab> to stick
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = vim.api.nvim_create_augroup("UnlinkLuaSnipSnippetOnModeChange", {
      clear = true,
    }),
    pattern = { "s:n", "i:*" },
    desc = "Forget the current snippet when leaving the insert mode",
    callback = function(evt)
      -- If we have n active nodes, n - 1 will still remain after a `unlink_current()` call.
      -- We unlink all of them by wrapping the calls in a loop.
      while true do
        if luasnip.session and luasnip.session.current_nodes[evt.buf] and not luasnip.session.jump_active then
          luasnip.unlink_current()
        else
          break
        end
      end
    end,
  })

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-e>"] = cmp.mapping {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      },
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ["<CR>"] = cmp.mapping.confirm { select = false },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    },
    formatting = {
      fields = { "abbr", "kind", "menu" },
      format = lspkind.cmp_format({
        mode = "text",
        menu = {
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
          emoji = "[Emoji]",
        },
        maxwidth = 50,
        ellipsis_char = "...",
      }),
    },
    sources = {
      { name = "nvim_lsp", priority = 1000 },
      { name = "nvim_lua", priority = 800 },
      { name = "luasnip", priority = 600 },
      { name = "path", priority = 400 },
      { name = "buffer", priority = 200},
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    experimental = {
      ghost_text = false,
    },
  }
end

return M
