return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
		},

		-- 保存時フォーマットはvim練習のため設定しないでおく
		-- format_on_save = {
		--    timeout_ms = 500,
		--  lsp_fallback = true,
		-- },
	},
}
