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

-- デバッグ: keybindsが読み込まれたか確認
wezterm.log_info("Loaded " .. #config.keys .. " keybindings")

-- コピーモード中に背景色を変更するイベントハンドラー
local last_mode = nil  -- 前回のモードを記憶してラグを減らす

wezterm.on('update-status', function(window, pane)
  local key_table = window:active_key_table()
  local is_copy_mode = (key_table == 'copy_mode' or key_table == 'search_mode')

  -- モードが変わってない場合は何もしない（パフォーマンス改善）
  if is_copy_mode == last_mode then
    return
  end
  last_mode = is_copy_mode

  local overrides = window:get_config_overrides() or {}

  if is_copy_mode then
    -- コピーモード中: 背景を黄色っぽくする（透明度はそのまま）
    overrides.colors = { background = '#3a382a' }  -- 黄色みがかった背景色
  else
    -- 通常モード: 元の設定に戻す
    overrides.colors = { background = nil }  -- デフォルトに戻す
  end

  window:set_config_overrides(overrides)
end)

return config
