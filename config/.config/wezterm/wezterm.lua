local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 【重要】WSL内のluaディレクトリを検索パスに追加する
-- Windowsから見たディレクトリに変更する
local wsl_dotfiles_path = "//wsl.localhost/Ubuntu-24.04/home/r-yamamoto/dotfiles/config/.config/wezterm/?.lua"
package.path = package.path .. ";" .. wsl_dotfiles_path

config.automatically_reload_config = true
config.window_frame = {
  font_size = 12.0,
}
config.color_scheme = "Tokyo Night"
config.window_background_opacity = 0.70
config.use_ime = true

-- タブバーを有効にしてステータス表示を可能にする
config.use_fancy_tab_bar = false  -- シンプルなタブバーを使用

-- カーソルとコピーモードのカラー設定
config.colors = {
  -- カーソルの色（全モード共通）
  cursor_bg = '#FFFF00',  -- 黄色（目立つ色）
  cursor_fg = '#000000',  -- 黒
  cursor_border = '#FFFF00',

  -- 選択範囲の色（コピーモードでも使用）
  selection_bg = '#FCA17D',  -- オレンジ系
  selection_fg = '#000000',  -- 黒

  -- コピーモードでの選択範囲（バグあり、動作しない可能性）
  copy_mode_active_highlight_bg = { Color = '#FCA17D' },
  copy_mode_active_highlight_fg = { Color = '#000000' },
  copy_mode_inactive_highlight_bg = { Color = '#52AD70' },
  copy_mode_inactive_highlight_fg = { Color = '#C0C0C0' },
}

-- タイトルバーが表示されなくなる
-- config.window_decorations = "RESIZE"

-- keybindsを読み込む
local keybinds = require("keybinds")
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables

-- 左下にモードを表示するイベントハンドラー
wezterm.on('update-status', function(window, pane)
  local key_table = window:active_key_table()

  -- モード表示用のテキストと色
  local mode_text = ''
  local mode_color = '#7aa2f7'  -- デフォルト（青）

  if key_table == 'copy_mode' or key_table == 'search_mode' then
    mode_text = ' COPY '
    mode_color = '#e0af68'  -- 黄色
  elseif key_table == 'resize_pane' then
    mode_text = ' RESIZE '
    mode_color = '#7aa2f7'  -- 青
  elseif key_table == 'leader' then
    mode_text = ' LEADER '
    mode_color = '#f7768e'  -- 赤
  end

  -- 左側のステータスバーに表示
  window:set_left_status(wezterm.format {
    { Background = { Color = mode_color } },
    { Foreground = { Color = '#1a1b26' } },
    { Text = mode_text },
  })

  -- 右側のステータスバーを空にする
  window:set_right_status('')
end)

return config
