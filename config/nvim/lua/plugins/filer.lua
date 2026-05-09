return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			filesystem = {
				follow_current_file = { enabled = true },
				hijack_netrw_behavior = "open_current",
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
			vim.api.nvim_set_hl(0, "NeoTreeFileStatsHeader", { fg = "#7aa2f7", bold = true })
			vim.api.nvim_set_hl(0, "NeoTreeFileStats", { fg = "#a9b1d6" })
			vim.api.nvim_set_hl(0, "NeoTreeDimText", { fg = "#a9b1d6" })
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			default_file_explorer = false,
			view_options = { show_hidden = true },
		},
	},
}
