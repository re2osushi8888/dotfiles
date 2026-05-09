return {
  {
    "mrcjkb/haskell-tools.nvim",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    config = function()
      vim.g.haskell_tools = {
        hls = {
          capabilities = require("blink.cmp").get_lsp_capabilities(),
        },
      }
    end,
  },
  {
    "luc-tielen/telescope_hoogle",
    dependencies = { "nvim-telescope/telescope.nvim" },
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    config = function()
      require("telescope").load_extension("hoogle")
    end,
  },
}
