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
config.window_background_opacity = 0.1  -- ぼかしON時の透過率
config.win32_system_backdrop = "Acrylic"  -- Windows向けのぼかし効果
config.use_ime = true

-- リガチャ（ligature）を無効化（===や->などの自動変換をオフ）
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- タブバーを有効にしてステータス表示を可能にする
config.use_fancy_tab_bar = false

-- keybindsを読み込む
local keybinds = require("keybinds")
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables

-- 左上にモードを表示するイベントハンドラー
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
