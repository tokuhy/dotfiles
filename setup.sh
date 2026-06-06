#!/bin/bash

# dotfilesを指定の場所に展開して環境を構築する

set -eu

# このスクリプトが置かれているディレクトリ（リポジトリの場所）を導出する
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# home directory以下に展開するdotfileを列挙
dotfiles="
.zshenv
.zshrc
.zprofile
.tmux.conf
.gitconfig
.gitattributes
.gitignore_global
.config/nvim
bin
"

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
    ;;
*)
    echo "option is [install/uninstall]"
    ;;
esac
