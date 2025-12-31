-- 自作のコマンドを発火する最初のキーを設定。spaceが多いらしい
vim.g.mapleader = " "

require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.diagnostics")
require("config.clipboard")

require("mason").setup()
require("mason-lspconfig").setup()

