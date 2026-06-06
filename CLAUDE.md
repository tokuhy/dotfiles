# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## 概要

macOS（Apple Silicon / zsh）向けの個人用 dotfiles リポジトリ。設定ファイルを `~/` 配下への
シンボリックリンクとして管理する。チームでの fork 共有も想定し、個人固有の設定（git identity、
SSH 鍵など）はリポジトリに含めず各自のローカルファイルに分離している。

## セットアップ

```bash
# インストール: 管理対象を ~/ 配下にシンボリックリンク
./setup.sh install

# アンインストール: このリポジトリが張ったシンボリックリンクのみ削除
./setup.sh uninstall
```

- `setup.sh` は `dotfiles` 変数に列挙されたファイル/ディレクトリをリンクする。管理対象を増やすには
  このリストを更新する。`.config/nvim` のようなネストした宛先にも対応（install 時に親ディレクトリを
  作成してからリンク）。
- install/uninstall は各操作を `link` / `ok`（リンク済み）/ `backup` / `remove` / `skip` と末尾サマリで
  表示する。既存の実体ファイルは `~/<name>.bak` に退避してからリンクする。
- 個人設定（管理対象外・各自で用意）:
  - `~/.gitconfig.local` … git の name / email（`.gitconfig.local.example` をコピーして編集）
  - `~/.gitconfig.work` … 会社用 identity（`~/workspaces/` 配下のみ適用、`.gitconfig.work.example`）
  - `~/.zshrc.mine` … マシン固有の zsh 設定（SSH 鍵の keychain ロード、gcloud SDK など）

## リポジトリ構成

- **`.zshrc`** — メインの zsh 設定: PATH、エイリアス、補完、プロンプト、履歴、キーバインド。
  末尾で `~/.zshrc.mine`（管理対象外）を読み込む。
- **`.tmux.conf`** — tmux 設定。プレフィックス `Ctrl+t`、ペイン分割 `prefix+h`（水平）/ `prefix+v`（垂直）。
  コピー/ペーストは macOS の `pbcopy` / `pbpaste` 連携。
- **`.config/nvim/init.lua`** — neovim 設定（デフォルトエディタ）。プラグインは使わず素の設定
  （文字コード、インデント、キーマップ、ステータスライン、全角スペース可視化）。配色は同梱の
  `.config/nvim/colors/desert256.vim`（`colorscheme desert256`）。
- **`.gitconfig`** — 共有の Git 設定。identity は持たず、末尾で `~/.gitconfig.local` を include、
  `~/workspaces/` 配下は `includeIf "gitdir:~/workspaces/"` で `~/.gitconfig.work` を include。
  alias（`st`、`df`、`co`、`b`、`pl`、`ps`）あり。
- **`.gitconfig.local.example` / `.gitconfig.work.example`** — identity テンプレート（symlink しない）。
- **`.gitattributes`** — 改行正規化（`* text=auto`、`*.sh eol=lf`）。`~/.gitattributes` に symlink。
- **`.gitignore_global`** — グローバルな除外設定（`core.excludesfile` → `~/.gitignore_global`）。
- **`bin/`** — PATH に追加される個人用スクリプト: `loadavg`（`sysctl` でロードアベレージを出力、
  tmux ステータスバーで使用）、`tmuxx`（tmux へ attach、無ければ新規作成）。

## 主な規約

- **個人/マシン固有設定の分離**: 共有ファイルに個人データを書かない。zsh は `~/.zshrc.mine`、
  git identity は `~/.gitconfig.local`（会社用は `~/workspaces/` 配下＋`~/.gitconfig.work`）に置く。
- **macOS（Apple Silicon）前提**: Homebrew は `/opt/homebrew/bin/brew shellenv` で初期化。
- **条件付き PATH エントリ**: `(N-/)` の glob 修飾子（例: `path=(~/bin(N-/) $path)`）で、存在しない
  ディレクトリを黙ってスキップさせる。
- **ツールの存在チェック**: pyenv / rbenv / nvm / Homebrew 等を有効化する前に、`if [ -d ... ]`
  （ディレクトリ確認）や `if [ -x ... ]`（実行ファイル確認）でガードする。
- **エディタ**: neovim を優先し、未導入なら vim にフォールバック（`type nvim` で判定して `EDITOR` を
  `nvim`/`vim` に設定、`vim`/`vi` alias は解決済みの `$EDITOR` を参照）。git のコミットエディタも
  `EDITOR` を継承。neovim 設定はプラグインを使わない方針。
- **対話確認 alias の Claude ガード**: `rm` / `cp` / `mv` の `-i` は `[[ -z "$CLAUDECODE" ]]` で囲み、
  Claude Code 実行時（`CLAUDECODE=1`）は無効化して自動処理が確認プロンプトで止まらないようにする。
- **コミットメッセージ**: Conventional Commits 形式。Claude 由来の署名・記述
  （`Co-Authored-By: Claude ...`、`🤖 Generated with Claude Code` など）を含めない。
