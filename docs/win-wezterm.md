# WSLでWeztermを使う方法
WindowsでWeztermをインストールし、WSLにあるdotfilesのwezterm設定を読み込む手順

## 参考文献
- https://wezterm.org/install/windows.html
- [WezTerm で快適な WSL2 環境にする](https://blog.1q77.com/2023/08/wezterm-on-windows/)]

## 手順
### 1. weztermインストール
powershellで以下を実行
```
winget install wez.wezterm
```
### 2. windows側でweztermの設定
※前提としてWSL2側のホームディレクトリ配下に`~/dotfiles`を展開していること

windows側でwslにあるdotfilesを読み込む
- powershell
	- ディストリビューション名を確認
		- `wsl -l -v`
	- ユーザーを確認
		- `wsl -d <DISTRO> -e whoami`
- explorer
	- `%USERPROFILE%`を検索し、`.wezterm.lua`を作成する
	- 内容は以下
```
# .wezterm.lua
local wezterm = require("wezterm")
local DISTRO = "<調べたディストリビューション名>"
local LINUX_USER = "<調べたユーザー名>"

-- WSL上の.config/wezterm設定を読み込む
local WSL_CONFIG = ([[\\wsl$\%s\home\%s\dotfiles\config\.config\wezterm\wezterm.lua]]):format(DISTRO, LINUX_USER)

local ok, cfg = pcall(dofile, WSL_CONFIG)
if not ok then
  wezterm.log_error("Failed to load WSL config: " .. tostring(cfg))
  cfg = {}
end

-- 起動時はWSLをデフォルトにする
local DOMAIN_NAME = "WSL:" .. DISTRO
cfg.wsl_domains = {
  {
    name = DOMAIN_NAME,
    distribution = DISTRO,
    default_cwd = "~",
  },
}

cfg.default_domain = DOMAIN_NAME

return cfg
```

### 3. 新規Paneを開いたときにWSLにつなぐ
 ※dotfiles内で実行するように設定しているので特にやる必要はない
 
 +ボタンなどで新規Pane開いたときにWindowsのユーザーで起動してしまう。
 [wezterm.sh](https://github.com/wezterm/wezterm/blob/main/assets/shell-integration/wezterm.sh)をコピーし、.zshrc内で`source PATH/wezterm.sh`を実行しておく
  

## トラブルシューティング
### windowsのExplorer側からwsl2のシンボリックリンクが見れない
stowで作ったシンボリックリンク`~/.config/wezterm/wezterm.lua`をwindows側のファイルから見に行ったらエラー
→バグが多いらしく実態ファイルを見に行く方がよさそう

AI回答
```
それ、かなり「あるある」で、原因はだいたい **Windows（エクスプローラー）側が WSL 内の Linux シンボリックリンクを正しく辿れない/表示がおかしくなる**ことです。特に `\\wsl$` 経由でアクセスしたときに起きやすいです。実際に「Windows 側で WSL の symlink が期待通りに扱えない」系の issue も複数上がっています。

あなたの状況を整理すると：
- WSL 内では `stow` で `~/.config/wezterm/wezterm.lua` を `~/dotfiles/...` に向けた **symlink** にしている
- Windows の WezTerm 設定から `\\wsl$\...` を参照しようとしている（または Explorer で見ている）
- Explorer で見ると「なぜか wezterm のファイルしか見えない」など表示が崩れる

このときの対策は、**Windows（WezTerm）から読むパスは “symlink を含まない実体ファイル” を指す**ようにするのが一番確実です。
```
