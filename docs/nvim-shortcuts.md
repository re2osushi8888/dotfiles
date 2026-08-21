# Neovim ショートカットチートシート

`<leader>` = `Space`

---

## 一般

| キー | モード | 機能 |
|------|--------|------|
| `jj` | Insert | `<Esc>` (ノーマルモードへ) |
| `<C-q>` | Normal | Visual Block (`<C-v>` 相当) |

---

## Telescope (ファイル検索)

| キー | 機能 |
|------|------|
| `<leader>ff` | ファイル検索 |
| `<leader>fg` | 全文検索 (live grep) |
| `<leader>fb` | バッファ一覧 |
| `<leader>fh` | ヘルプタグ検索 |

---

## ファイラ

| キー | 機能 |
|------|------|
| `-` | Oil: 親ディレクトリを開く |
| `<leader>ef` | Neo-tree: フロート表示 |
| `<leader>es` | Neo-tree: サイドバー表示 |

---

## コード編集

| キー | 機能 |
|------|------|
| `<leader>f` | フォーマット (conform.nvim) |
| `<leader>d` | 診断をフロートで表示 |

---

## LSP

### Telescope 統合 (LspAttach 時に有効)

| キー | モード | 機能 |
|------|--------|------|
| `gd` | Normal | 定義へジャンプ (Telescope) |
| `grr` | Normal | 参照一覧 (Telescope) ※デフォルト上書き |
| `gri` | Normal | 実装へジャンプ (Telescope) ※デフォルト上書き |
| `grt` | Normal | 型定義へジャンプ (Telescope) ※デフォルト上書き |
| `gO` | Normal | ドキュメントシンボル (Telescope) ※デフォルト上書き |
| `<leader>ws` | Normal | ワークスペースシンボル |
| `<leader>wS` | Normal | ワークスペースシンボル (動的) |
| `<leader>ci` | Normal | 呼び出し元一覧 (Incoming Calls) |
| `<leader>co` | Normal | 呼び出し先一覧 (Outgoing Calls) |

### 生 LSP (Telescope 非対応 / LspAttach 時に有効)

| キー | モード | 機能 |
|------|--------|------|
| `gD` | Normal | 宣言へジャンプ |
| `gK` | Normal | シグネチャヘルプ |
| `<C-k>` | Insert | シグネチャヘルプ |

### Neovim 0.12 デフォルト (常に有効)

| キー | 機能 |
|------|------|
| `K` | ホバードキュメント (LspAttach 時のみ有効) |
| `grn` | リネーム |
| `gra` | コードアクション |
| `grx` | CodeLens 実行 |
| `<C-S>` | シグネチャヘルプ (Insert/Select) |

---

## 補完 (blink.cmp)

| キー | 機能 |
|------|------|
| `<Tab>` | 候補を確定 / スニペット次へ |
| `<S-Tab>` | スニペット前へ |
| `<C-Space>` | 補完を手動表示 |
| `<C-e>` | 補完を閉じる |
| `<C-p>` / `<C-n>` | 候補を上下移動 |
| `<CR>` | 補完を確定しない (fallback) |

---

## Haskell 専用 (ftplugin)

| キー | 機能 |
|------|------|
| `<space>cl` | CodeLens を実行 |
| `<space>hs` | Hoogle: カーソル下の型を検索 |
| `<space>ea` | コードスニペットをすべて評価 |
| `<leader>rr` | GHCi REPL: パッケージ単位でトグル |
| `<leader>rf` | GHCi REPL: バッファ単位でトグル |
| `<leader>rq` | GHCi REPL: 終了 |
| `<leader>hh` | Telescope Hoogle 検索 |
