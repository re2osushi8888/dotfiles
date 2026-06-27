return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			rust = { "rustfmt" },
			go = { "gofumpt" },
		},

		-- 保存時フォーマットはvim練習のため設定しないでおく
		-- format_on_save = {
		--    timeout_ms = 500,
		--  lsp_fallback = true,
		-- },
	},
}
