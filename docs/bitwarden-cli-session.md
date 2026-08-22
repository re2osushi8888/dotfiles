# Bitwarden CLI のセッション管理方式

- **ステータス**: Accepted
- **決定日**: 2026-08-22

## コンテキスト

`bw` (Bitwarden CLI) を導入し、`nix/home/common.nix` の `packages` に `bitwarden-cli` を追加した。`bw` でシークレットを取得するには `bw unlock` でセッションキー (`BW_SESSION`) を取得する必要があるが、このセッションキーは仕様上ディスクに永続化されず、新しいターミナルセッションを開くたびに失効する。そのため、毎回 `export BW_SESSION="$(bw unlock --raw)"` を打つのは煩雑で、かといって `.zshrc` に静的に export すると、そのファイルを Git 管理・共有した際にセッション情報が漏れるリスクがある。

## 決定

**`BW_SESSION` を `.zshrc` (home-manager の `initContent`) に静的に export しない。代わりに `bwu` というシェル関数を定義し、呼び出された時にロック状態を確認してから必要な場合だけ `bw unlock` する。**

```bash
bwu() {
  if [ "$(bw status | jq -r '.status')" = "unlocked" ]; then
    echo "bw: already unlocked"
  else
    export BW_SESSION="$(bw unlock --raw)"
  fi
}
```

シェル起動時に自動でパスワードを求められることはなく、シークレットが必要になったタイミングで `bwu` を明示的に叩く運用とする。

**検討した代替案：**

- **`.zshrc` に `BW_SESSION` を静的 export**: シェル起動のたびにマスターパスワード入力を求められ体験が悪い上、シェル設定ファイルというセキュリティ意識が低くなりがちな場所にセッション情報を置くことになるため却下。
- **`--passwordenv`/`--passwordfile` でマスターパスワード自体を自動供給**: パスワードを環境変数やファイルに平文で置くことになり、Bitwarden を使う目的（秘密情報を安全に管理する）と本末転倒なため却下。
- **macOS Keychain 等 OS のセキュアストレージにセッションを保存するサードパーティスクリプト**: Bitwarden 公式でもまだ議論中の機能であり、非公式スクリプトへの依存や `sudo`/root 権限を使う複雑な実装が必要になるため、現時点ではオーバーエンジニアリングと判断し却下。
- **chezmoi のネイティブ Bitwarden 統合**: dotfiles 管理に chezmoi を使っていない（home-manager + Nix flake 構成のため）ため対象外。

## 結果

**利点：**

- シェル設定ファイルにシークレットやセッション情報を一切書かない
- ロック済みなら再unlockをスキップするため、無駄なパスワード入力を避けられる
- 実装がシンプルで、home-manager の Nix 記述内に閉じている

**欠点：**

- シェルを新しく開くたびに、シークレットを使う直前に `bwu` を手動で呼ぶ必要がある（完全自動化ではない）
- `bw status` を毎回呼ぶため、`bwu` 実行時にわずかなオーバーヘッドがある

## 参考

- [Gruntwork: How to securely store secrets in BitWarden CLI](https://www.gruntwork.io/blog/how-to-securely-store-secrets-in-bitwarden-cli-and-load-them-into-your-zsh-shell-when-needed)
- [Password Manager CLI | Bitwarden](https://bitwarden.com/help/cli/)
- [Persist cli unlock - Bitwarden Community Forums](https://community.bitwarden.com/t/persist-cli-unlock/18982)
