return {
  "folke/tokyonight.nvim",
  priority = 1000, -- 最初に読み込ませる

  config = function()
    require("tokyonight").setup({
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hi, c)
        hi.LineNr = {
          fg = c.dark,
        }
        hi.CursorLineNr = {
          fg = c.blue5,
          bold = true,
        }
        -- 相対行の上の行のカラースキーム
        hi.LineNrAbove = {
          fg = c.blue5,
        }
        -- 相対行の下の行のカラースキーム
        hi.LineNrBelow = {
          fg = c.blue5,
        }
        -- WinSeparator(枠線)のカラースキーム
        hi.WinSeparator = {
          fg = c.blue5,
          bold = true,
        }
      end,
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
