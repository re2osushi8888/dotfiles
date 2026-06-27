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
    },
  },
}
