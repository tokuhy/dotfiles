# dotfiles

macOS（Apple Silicon / zsh）向けの個人用 dotfiles。設定ファイルを `~/` 配下へのシンボリック
リンクとして管理する。チームでの fork 共有も想定し、個人固有の設定（git identity 等）は
リポジトリに含めず各自のローカルファイルに分離している。

## 要件

- macOS（Apple Silicon 前提）
- zsh
- [Homebrew](https://brew.sh/)
- 推奨ツール: `nvim`（neovim / デフォルトエディタ）, `tmux`
- 任意: `git-lfs`（LFS を使うリポジトリがある場合のみ）

## インストール

```sh
$ cd ~
$ git clone https://github.com/tokuhy/dotfiles.git
$ cd dotfiles
$ ./setup.sh install
```

`setup.sh install` は管理対象（下記）を `~/` 配下にシンボリックリンクする。各操作は
`link` / `ok`（リンク済み）/ `backup` / `skip` と末尾サマリで表示される。既存の実体ファイルが
あった場合は `~/<name>.bak` に退避してからリンクする。

## 各自の初期設定

git の identity（name / email）は共有しないので、各自 `~/.gitconfig.local` に設定する
（共有 `.gitconfig` 末尾から include。後勝ちで上書き可能）。

```sh
$ cp ~/dotfiles/.gitconfig.local.example ~/.gitconfig.local
$ vi ~/.gitconfig.local   # name / email を自分のものに編集
```

会社のリポジトリは `~/workspaces/` 配下に clone すると、その配下でだけ自動的に会社の
identity でコミットされる（`~/workspaces/` 外は個人 identity）。仕組みは `.gitconfig` の
`includeIf "gitdir:~/workspaces/"`。

```sh
$ cp ~/dotfiles/.gitconfig.work.example ~/.gitconfig.work
$ vi ~/.gitconfig.work   # 会社の name / SSO アドレスに編集
```

git-lfs を使うリポジトリがある場合のみ、各自で有効化する。

```sh
$ git lfs install
```

## 管理対象ファイル

| パス | 内容 |
|------|------|
| `.zshenv` / `.zshrc` / `.zprofile` | zsh 設定。`.zshrc` は PATH・エイリアス・補完・プロンプト・履歴・キーバインド。`EDITOR=nvim`、`vim`/`vi` は `nvim` の alias |
| `.tmux.conf` | tmux 設定。プレフィックス `Ctrl+t`、ペイン分割 `prefix+h`（水平）/`prefix+v`（垂直）。コピー/ペーストは `pbcopy`/`pbpaste` 連携 |
| `.config/nvim/init.lua` | neovim 設定（デフォルトエディタ）。プラグインなしの素設定（文字コード・インデント・キーマップ・ステータスライン・全角スペース可視化） |
| `.config/nvim/colors/desert256.vim` | 同梱の配色（`colorscheme desert256`） |
| `.gitconfig` | 共有の git 設定。個人 identity は `~/.gitconfig.local`、会社用は `~/.gitconfig.work`（`~/workspaces/` 配下）に分離 |
| `.gitattributes` | 改行正規化（`* text=auto`、`*.sh eol=lf`）等 |
| `.gitignore_global` | グローバルな除外設定（`core.excludesfile` から参照） |
| `bin/loadavg` | tmux ステータスバー用のロードアベレージ出力（`sysctl` ベース） |
| `bin/tmuxx` | tmux セッションへ attach、無ければ新規作成 |

> `.gitconfig.local.example` / `.gitconfig.work.example` はテンプレートで、symlink されない（各自コピーして使う）。

## カスタマイズ

- **マシン固有の zsh 設定**は `~/.zshrc.mine`（管理対象外）に置く。`.zshrc` は末尾でこれを読み込む。
- **管理対象を増やす**には `setup.sh` の `dotfiles` リストにパスを追加する。`.config/nvim` のような
  ネストしたパスにも対応している。

## アンインストール

```sh
$ ./setup.sh uninstall
```

このリポジトリが張ったシンボリックリンクのみ削除する（実体ファイルや `.bak` は残す）。
各操作は `remove` / `skip` と末尾サマリで表示される。
