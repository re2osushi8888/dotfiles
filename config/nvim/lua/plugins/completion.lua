return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    opts = {
      keymap = {
        preset = 'default',
        ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        ['<CR>'] = { 'fallback' },
      },
      sources = {
        providers = {
          cmdline = {
            -- WSLではPATH上のWindows側実行ファイル(/mnt/c/...)の列挙が遅く、
            -- :! (シェルコマンド)実行時に補完が固まって見えるため無効化する
            enabled = function()
              return vim.fn.getcmdtype() ~= ':' or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
            end,
          },
        },
      },
    },
  },
}
