return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          -- プレビューの表示設定
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              preview_width = 0.55,
            },
          },
        },
        pickers = {
          find_files = {
            -- 隠しファイルも表示
            hidden = true,
            -- .gitignoreを無視してすべてのファイルを表示する場合は以下をコメント解除
            -- no_ignore = true,
            -- より高速な検索のためにfdを使用（インストールされている場合）
            find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
          },
        },
      })
    end,
  },
}
