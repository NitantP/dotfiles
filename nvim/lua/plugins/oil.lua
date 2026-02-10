local opts = {
	columns = {
		"icon",
		"mtime",
	},

	keymaps = {
		["<C-v>"] = "actions.select_vsplit",
		["<C-x>"] = "actions.select_split",
		["<C-h>"] = false,
		["<C-l>"] = false,
	},
}

return {
	"stevearc/oil.nvim",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		require("oil").setup(opts)

		-- keymaps
		local keymap = vim.keymap

		keymap.set("n", "<leader><leader>", "<cmd>Oil<CR>", { desc = "Open file explorer" })
	end,
}
