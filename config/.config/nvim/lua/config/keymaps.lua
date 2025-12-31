-- esc�L�[�̃G�C���A�X
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- vim.diagnostic setting
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)

-- telescopeのエイリアス
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<Leader>fg", builtin.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
-- Ctrl+Q でVisualBlock(短形選択)
vim.keymap.set("n", "<C-q>", "<C-v>", { noremap = true })

-- NeoVimTreeのエイリアス
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { silent = true })

-- conform.nvimでのformatのエイリアス
vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

