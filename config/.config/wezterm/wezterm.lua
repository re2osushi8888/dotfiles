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

-- タイトルバーが表示されなくなる
-- config.window_decorations = "RESIZE"

-- keybindsを読み込む
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables

return config
