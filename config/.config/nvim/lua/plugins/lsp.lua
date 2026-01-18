return {
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
      vim.lsp.config("hls", {
        cmd = { "haskell-language-server-wrapper", "--lsp" },
        filetypes = { "haskell", "lhaskell" },

        root_markers = {
          "stack.yaml",
          "cabal.project",
          "*.cabal",
          "package.yaml",
          "hie.yaml",
          ".git",
        },
        settings = {
          haskell = {
            formattingProvider = "fourmolu",
          },
        },
      })
		end,
	},
}
