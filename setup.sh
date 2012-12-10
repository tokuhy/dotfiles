#!/bin/bash

# dotfilesを指定の場所に展開して環境を構築する

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
    if [ -f ~/dotfiles/.ssh/config ];then
        chmod 600 ~/dotfiles/.ssh/config
        ln -fs ~/dotfiles/.ssh/config ~/.ssh/
    fi
    ;;
"uninstall")
    # 削除
    for f in $dotfiles;do
        rm -f ~/$f
    done
    rm -f ~/.ssh/config
    ;;
*)
    echo "option is [install/uninstall]"
    ;;
esac
