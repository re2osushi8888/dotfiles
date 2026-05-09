return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = "rafamadriz/friendly-snippets",
    version = "v0.*",
    opts = {
      keymap = {
        preset = 'default',
        ['<CR>'] = { 'accept', 'fallback' },
      },
    },
  },
}
