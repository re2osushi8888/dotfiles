return {
  "mrcjkb/haskell-tools.nvim",
  version = "^6",
  lazy = false,
  ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
  config = function()
    vim.g.haskell_tools = {
      hls = {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      },
    }
  end,
}
