#!/bin/bash

# dotfilesを指定の場所に展開して環境を構築する

# home directory以下に展開するdotfileを列挙
dotfiles="
.ssh/config
.zshrc
.tmux.conf
.vimrc
.gvimrc
.screenrc
.gitconfig
.vim
bin
"

## install
case $1 in
"install")
    # 展開
    for f in $dotfiles;do
        if [ -f ~/dotfiles/$f -o -d ~/dotfiles/$f ];then
            ln -fs ~/dotfiles/$f ~/
        fi
    done
    ;;
"uninstall")
    # 削除
    for f in $dotfiles;do
        rm -f ~/$f
    done
    ;;
*)
    echo "option is [install/uninstall]"
    ;;
esac
