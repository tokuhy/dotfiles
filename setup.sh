#!/bin/bash

# dotfilesを指定の場所に展開して環境を構築する

set -eu

# このスクリプトが置かれているディレクトリ（リポジトリの場所）を導出する
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# home directory以下に symlink する dotfile を列挙
# 注: bin は丸ごとではなくファイル単位（bin/loadavg, bin/tmuxx）で列挙する。
#     ~/bin をディレクトリごと symlink すると、既に ~/bin を持つ環境では中身が
#     まるごと ~/bin.bak に退避されてしまうため、個別ファイルだけをリンクする。
# 注: .gitconfig はここに含めない。直接 symlink すると `git config --global`
#     （gh auth login 等）の書き込みが symlink を辿って追跡ファイルを汚すため、
#     各自の実体 ~/.gitconfig から include させる方式で別途扱う。
dotfiles="
.zshrc
.tmux.conf
.gitattributes
.gitignore_global
.config/nvim
.config/npm/npmrc
bin/loadavg
bin/tmuxx
"

# 共有 .gitconfig の絶対パス（各自の ~/.gitconfig から include させる）
SHARED_GITCONFIG="$DOTFILES_DIR/.gitconfig"

## install
case ${1:-} in
"install")
    echo "==> install dotfiles (source: $DOTFILES_DIR)"
    linked=0
    already=0
    backed_up=0
    skipped=0
    # 展開
    for f in $dotfiles; do
        if [ ! -e "$DOTFILES_DIR/$f" ]; then
            echo "skip : $f (source not found)"
            skipped=$((skipped + 1))
            continue
        fi
        # 既に正しい先を指すシンボリックリンクがあれば張り直さない
        if [ -L ~/"$f" ] && [ "$(readlink ~/"$f")" = "$DOTFILES_DIR/$f" ]; then
            echo "ok   : ~/$f (already linked)"
            already=$((already + 1))
            continue
        fi
        # 既存の実体ファイル/ディレクトリ（シンボリックリンクを除く）はバックアップする
        if [ -e ~/"$f" ] && [ ! -L ~/"$f" ]; then
            echo "backup: ~/$f -> ~/$f.bak"
            mv ~/"$f" ~/"$f.bak"
            backed_up=$((backed_up + 1))
        fi
        # ネストした宛先（例: .config/nvim）のために親ディレクトリを用意する
        mkdir -p "$(dirname ~/"$f")"
        # -n: 既存のシンボリックリンク先ディレクトリを辿らず置き換える
        ln -fns "$DOTFILES_DIR/$f" ~/"$f"
        echo "link : ~/$f -> $DOTFILES_DIR/$f"
        linked=$((linked + 1))
    done
    echo "done: ${linked} linked, ${already} already, ${backed_up} backed up, ${skipped} skipped"

    # .gitconfig は symlink せず、各自の実体 ~/.gitconfig から include させる。
    # こうすれば `git config --global`（gh auth login 等）の書き込みは各自ファイルに入り、
    # 共有の追跡ファイルを汚さない。
    if [ -L ~/.gitconfig ] && [ "$(readlink ~/.gitconfig)" = "$SHARED_GITCONFIG" ]; then
        # 旧構成（.gitconfig を直接 symlink）からの移行: symlink を include ファイルに置き換える
        rm -f ~/.gitconfig
        printf '[include]\n\tpath = %s\n' "$SHARED_GITCONFIG" > ~/.gitconfig
        echo "migrate: ~/.gitconfig (symlink -> include file)"
    elif [ ! -e ~/.gitconfig ]; then
        # 無ければ include 行だけの新規ファイルを作る
        printf '[include]\n\tpath = %s\n' "$SHARED_GITCONFIG" > ~/.gitconfig
        echo "create : ~/.gitconfig (include shared .gitconfig)"
    elif ! git config --global --get-all include.path 2>/dev/null | grep -qF "$SHARED_GITCONFIG"; then
        # 既存ファイルに include 未記載なら先頭に追記（冪等・各自の他設定は保持）
        printf '[include]\n\tpath = %s\n' "$SHARED_GITCONFIG" | cat - ~/.gitconfig > ~/.gitconfig.tmp
        mv ~/.gitconfig.tmp ~/.gitconfig
        echo "update : ~/.gitconfig (prepend include of shared .gitconfig)"
    else
        echo "ok   : ~/.gitconfig (already includes shared .gitconfig)"
    fi
    ;;
"uninstall")
    echo "==> uninstall dotfiles (remove symlinks created by this repo)"
    removed=0
    skipped=0
    # 削除（このリポジトリが張ったシンボリックリンクのみ）
    for f in $dotfiles; do
        if [ -L ~/"$f" ]; then
            rm -f ~/"$f"
            echo "remove: ~/$f"
            removed=$((removed + 1))
        else
            echo "skip : ~/$f (not a symlink)"
            skipped=$((skipped + 1))
        fi
    done
    echo "done: ${removed} removed, ${skipped} skipped"

    # 追加した include 行だけを ~/.gitconfig から除去する（各自の他設定は残す）。
    if [ -f ~/.gitconfig ] && git config --global --get-all include.path 2>/dev/null | grep -qF "$SHARED_GITCONFIG"; then
        # 値は正規表現として扱われるため、英数字以外を全てエスケープして安全に一致させる
        pattern="$(printf '%s' "$SHARED_GITCONFIG" | sed 's/[^a-zA-Z0-9]/\\&/g')"
        git config --global --unset-all include.path "$pattern"
        echo "remove: include of shared .gitconfig from ~/.gitconfig"
    else
        echo "skip : ~/.gitconfig (no include of shared .gitconfig)"
    fi
    ;;
*)
    echo "option is [install/uninstall]" >&2
    exit 1
    ;;
esac
