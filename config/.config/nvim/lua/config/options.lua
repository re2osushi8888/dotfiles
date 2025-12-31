-- 相対的な行数を表示する
vim.opt.number = true
vim.opt.relativenumber = true

-- カーソル行をハイライトする
vim.opt.cursorline = true
vim.opt.cursorlineopt = { "number", "line" }

-- 背景の透明化
vim.opt.termguicolors = true
vim.opt.winblend = 0 -- ウィンドウの不透明度
vim.opt.pumblend = 0 -- ポップアップメニューの不透明度

-- tab�ݒ�, ��{space2�ɂ���
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- clipboard連携
vim.opt.clipboard = "unnamedplus"
