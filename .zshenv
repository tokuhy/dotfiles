# 言語設定
export LANG=ja_JP.UTF-8
# 環境設定
export PAGER=less
# PATH(macのhomebrew用)
export PATH=~/bin:/usr/local/bin:$PATH

# pyenv環境があれば実行
if [ -d $HOME/.pyenv ];then
    eval "$(pyenv init -)"
    export PATH="$HOME/.pyenv/bin:$PATH"
fi
# rbenv環境があれば実行
if [ -d $HOME/.rbenv ];then
    eval "$(rbenv init -)";
    export PATH="$HOME/.rbenv/bin:$PATH"
fi

# editor
export EDITOR=/usr/bin/vim

# 重複したPATHを除外する
# PATH 設定の前に持ってくるとうまく動かないのでここに
typeset -U path cdpath fpath manpath

## alias設定
# 補完前にaliasを展開する
setopt complete_aliases

alias where="command -v"
alias j="jobs -l"
# OSの違いによる設定
case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -G -w"
    alias grep="grep --color=always"
    ;;
linux*)
    alias ls="ls --color=always"
    alias grep="grep --color=always"
    ;;
solaris*)
    alias ls="/usr/gnu/bin/ls --color=always"
    alias grep="/usr/gnu/bin/grep --color=always"
    ;;
esac

alias la="ls -al"
alias lf="ls -F"
alias ll="ls -l"
alias du="du -h"
alias df="df -h"
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias vi="vim"
alias less="less -R"
alias g="git "
alias be="bundle exec"
alias bes="bundle exec spring"

# sudo のエイリアス対応
alias sudo="sudo "
# tmux 256色対応
alias tmux="tmux -2"

case "${OSTYPE}" in
darwin*)
    alias updateports="sudo port selfupdate; sudo port outdated"
    alias portupgrade="sudo port upgrade installed"
    alias vi="/Applications/MacVim.app/Contents/MacOS/Vim"
    alias tm="tmuxx"
    alias tma="tmux attach"
    alias tml="tmux list-window"
    ;;
freebsd*)
    case ${UID} in
    0)
        updateports()
        {
            if [ -f /usr/ports/.portsnap.INDEX ]
            then
                portsnap fetch update
            else
                portsnap fetch extract update
            fi
            (cd /usr/ports/; make index)

            portversion -v -l \<
        }
        alias appsupgrade='pkgdb -F && BATCH=YES NO_CHECKSUM=YES portupgrade -a'
        ;;
    esac
    ;;
esac

