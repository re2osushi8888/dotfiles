require("config.lazy")

require("mason").setup()
require("mason-lspconfig").setup()

-- 自作のコマンドを発火する最初のキーを設定。spaceが多いらしい
vim.g.mapleader = " "

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<Leader>fg", builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- 相対的な行数を表示する
vim.opt.number = true
vim.opt.relativenumber = true

-- カーソル行をハイライトする
vim.opt.cursorline = true
vim.opt.cursorlineopt = { "number", "line" }

-- escキーのエイリアス
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- 背景の透明化
vim.opt.termguicolors = true
vim.opt.winblend = 0 -- ウィンドウの不透明度
vim.opt.pumblend = 0 -- ポップアップメニューの不透明度

-- Ctrl+Q で Visual Block（短形選択）
vim.keymap.set("n", "<C-q>", "<C-v>", { noremap = true })

-- NeoVimTreeのエイリアス
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { silent = true })

-- formatのエイリアス
vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

-- vim.diagnostic setting
-- エラーダイアログを見る
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
-- 怒られるlspがわかる
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
  float = {
    border = "rounded",
    source = false,
    format = function(d)
      local code = d.code and (" [" .. d.code .. "]") or ""
      local src = d.source and (" (" .. d.source .. ")") or ""
      return d.message .. code .. src
    end,
  },
})

-- tab設定, 基本space2つにする
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- クリップボード連携
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = { "bash", "-lc", "iconv -f utf-8 -t utf-16le | clip.exe" },
      ["*"] = { "bash", "-lc", "iconv -f utf-8 -t utf-16le | clip.exe" },
    },
    paste = {
      ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
-- vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.clipboard = "unnamedplus"
