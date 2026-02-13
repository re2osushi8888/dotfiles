# dotfiles

## 環境構築

### 前提条件
wsl2のUbuntuで実施を想定している。適宜読み替えてください。
下記がインストールされていること
- zsh
- git

### 手順
#### GNU stowのインストール
シンボリックリンクを張るためにGNU stowをインストール
```
sudo apt update
sudo apt install -y stow
```

#### ホームディレクトリでdotfiles をgit clone
```
cd ~
git clone https://github.com/re2osushi8888/dotfiles.git
cd dotfiles
```

#### stow で dotfiles/ 配下からシンボリックリンクを張る
今の構成だとホームディレクトリ配下にdotfiles/がないと行けないので注意  
任意のディレクトリにdotfiles/やシンボリックリンクを張りたければ`--target DIR_NAME`などのオプションをつける

ドライラン
```
cd ~/dotfiles
stow -vvn config
```

実行
```
cd ~/dotfiles
stow -vv config
```

シンボリックリンク削除
```
cd ~/dotfiles 
stow -vvD config
```

#### miseでコマンドをインストール
まずはmise自体をインストールする
```
curl https://mise.run/zsh | sh
```

ホームディレクトリに移動してmise installを実行する。  
ホームディレクトリに移動しないとディレクトリ専用のmise.tomlが生成されてしまう。  
`~/.config/mise/config.toml`を参照するためにホームディレクトリに移動すること。
```
cd ~
mise install
```

終わったらzshを再起動する
```
exec zsh -l
```

#### おまけ：zshインストール・反映
下記コマンドを実行した後再起動
```
sudo apt update
sudo apt install -y zsh

chsh -s "$(which zsh)"
```

