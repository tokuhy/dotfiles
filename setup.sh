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
.vimrc
.gvimrc
.screenrc
.gitconfig
.gitattributes
.gitignore
.gitmodules
.vim
.gemrc
bin
"

## install
case ${1:-} in
"install")
    # 展開
    for f in $dotfiles; do
        if [ -e "$DOTFILES_DIR/$f" ]; then
            # 既存の実体ファイル/ディレクトリ（シンボリックリンクを除く）はバックアップする
            if [ -e ~/"$f" ] && [ ! -L ~/"$f" ]; then
                echo "backup: ~/$f -> ~/$f.bak"
                mv ~/"$f" ~/"$f.bak"
            fi
            # -n: 既存のシンボリックリンク先ディレクトリを辿らず置き換える
            ln -fns "$DOTFILES_DIR/$f" ~/
        fi
    done
    ;;
"uninstall")
    # 削除（このリポジトリが張ったシンボリックリンクのみ）
    for f in $dotfiles; do
        if [ -L ~/"$f" ]; then
            rm -f ~/"$f"
        fi
    done
    ;;
*)
    echo "option is [install/uninstall]"
    ;;
esac
