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

-- Neo-treeのエイリアス
vim.keymap.set("n", "<leader>ef", "<cmd>Neotree toggle position=float<CR>", { silent = true, desc = "Neo-tree (float)" })
vim.keymap.set("n", "<leader>es", "<cmd>Neotree toggle position=left<CR>", { silent = true, desc = "Neo-tree (sidebar)" })
-- oil.nvimのエイリアス
vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })

-- conform.nvimでのformatのエイリアス
vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

-- LSP (LazyVim スタイル + Telescope 統合)
-- nvim 0.12 デフォルト: K=hover, grn=rename, gra=code_action, grr=references,
--   gri=implementation, grt=type_definition, grx=codelens, gO=document_symbol,
--   <C-S>(i/s)=signature_help
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local tb = require("telescope.builtin")

    -- Telescope で上書き (デフォルトの gr*/gO をピッカー UI に)
    vim.keymap.set("n", "gd",  tb.lsp_definitions,              { buffer = buf, desc = "Go to Definition" })
    vim.keymap.set("n", "grr", tb.lsp_references,               { buffer = buf, desc = "References" })
    vim.keymap.set("n", "gri", tb.lsp_implementations,          { buffer = buf, desc = "Implementations" })
    vim.keymap.set("n", "grt", tb.lsp_type_definitions,         { buffer = buf, desc = "Type Definitions" })
    vim.keymap.set("n", "gO",  tb.lsp_document_symbols,         { buffer = buf, desc = "Document Symbols" })

    -- 新規 (Telescope のみ / デフォルトなし)
    vim.keymap.set("n", "<leader>ws", tb.lsp_workspace_symbols,         { buffer = buf, desc = "Workspace Symbols" })
    vim.keymap.set("n", "<leader>wS", tb.lsp_dynamic_workspace_symbols, { buffer = buf, desc = "Dynamic Workspace Symbols" })
    vim.keymap.set("n", "<leader>ci", tb.lsp_incoming_calls,            { buffer = buf, desc = "Incoming Calls" })
    vim.keymap.set("n", "<leader>co", tb.lsp_outgoing_calls,            { buffer = buf, desc = "Outgoing Calls" })

    -- Telescope 非対応 (生 LSP のまま)
    vim.keymap.set("n", "gD",    vim.lsp.buf.declaration,    { buffer = buf, desc = "Go to Declaration" })
    vim.keymap.set("n", "gK",    vim.lsp.buf.signature_help, { buffer = buf, desc = "Signature Help" })
    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = buf, desc = "Signature Help" })
  end,
})

