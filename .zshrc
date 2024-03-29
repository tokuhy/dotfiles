# 言語設定
export LANG=ja_JP.UTF-8
# 環境設定
export PAGER=less

# homeberwでzsh-completionsがある場合の設定
if type brew &>/dev/null;then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  # PATH(macのhomebrew用)
  export PATH=$(brew --prefix)/bin:$PATH
fi

#path=xxxx(N-/)
#  (N-/): 存在しないディレクトリは登録しない
#  パス(...): ...という条件にマッチするパスのみ残す
#     N: NULL_GLOBオプションを設定。
#        globがマッチしなかったり存在しないパスを無視する
#     -: シンボリックリンク先のパスを評価
#     /: ディレクトリのみ残す
#     .: 通常のファイルのみ残す

# ホームディレクトリ配下にbinがあるときだけ追加
path=(~/bin(N-/) $PATH)

# pyenv環境があれば実行
if [ -d $HOME/.pyenv ];then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
fi
# rbenv環境があれば実行
if [ -d $HOME/.rbenv ];then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)";
fi

# 重複したPATHを除外する
# PATH 設定の前に持ってくるとうまく動かないのでここに
typeset -U path cdpath fpath manpath

# editor
export EDITOR=/usr/bin/vim

## alias設定
# 補完前にaliasを展開する
setopt complete_aliases

alias where="command -v"
alias j="jobs -l"
# OSの違いによる設定
case "${OSTYPE}" in
darwin*)
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
    alias tm="tmuxx"
    alias tma="tmux attach"
    alias tml="tmux list-window"
    ;;
esac

# プロンプトの設定 rootのみカラー変更
autoload colors
colors
case ${UID} in
0)
    PROMPT="%B%{${fg[green]}%}${HOST%%.*} #%{${reset_color}%}%b "
    RPROMPT="%B%{${fg[cyan]}%}%/#%{${reset_color}%}%b "
    PROMPT2="%B%{${fg[cyan]}%}%_#%{${reset_color}%}%b "
    SPROMPT="%B%{${fg[cyan]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
    ;;
*)
    case ${OSTYPE} in
    darwin*)
        PROMPT="%B%{${fg[black]}%}%{${bg[cyan]}%}${USERNAME}@${HOST%%.*} $%{${reset_color}%}%b "
        ;;
    *)
        PROMPT="%B%{${fg[black]}%}%{${bg[green]}%}${USERNAME}@${HOST%%.*} $%{${reset_color}%}%b "
        ;;
    esac
    RPROMPT="%B%{${fg[cyan]}%}%/#%{${reset_color}%}%b "
    PROMPT2="%{${fg[cyan]}%}%_%%%{${reset_color}%} "
    SPROMPT="%{${fg[cyan]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
    ;;
esac

# cdコマンドなしでディレクトリ名直接指定で移動する
setopt auto_cd
# cd -[tab]でcdの履歴を参照して移動できるようにする
setopt auto_pushd
# ディレクトリスタックに同じディレクトリを追加しないようになる
setopt pushd_ignore_dups
# コマンド入力に間違いがある場合候補の提示
setopt correct
# コマンドライン全てのスペルチェックをする
setopt correct_all
# 補完候補を詰めて表示
setopt list_packed
# 補完候補が複数ある時に、一覧表示する
setopt auto_list
# auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示
setopt list_types
# パスの最後の/を自動削除しない
setopt noautoremoveslash
# 補完時にbeep音を出さない
setopt nolistbeep
# 拡張グロブ
setopt extended_glob
# 上書きリダイレクトの禁止
setopt no_clobber
# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst
# カッコの対応などを自動的に補完する
setopt auto_param_keys
# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
# {a-c} を a b c に展開する機能を使えるようにする
setopt brace_ccl
# 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完する
setopt auto_menu
# sudoも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# url特殊文字を自動でエスケープ
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# emacsライクなキーバインド。Ctrl-AやCtrl-Eなど
bindkey -e

# Ctrl-PとCtrl-Nでコマンド履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# Ctrl-W で削除を / を単語区切りに加える
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# コマンド履歴設定(10万件)
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
# 重複するコマンド履歴の排除
setopt hist_ignore_dups
# 履歴の共有
setopt share_history
# 余分な空白は詰める
setopt hist_reduce_blanks
# コマンド実行時に即座にヒストリファイルに追記
setopt inc_append_history

# 補完機能
# 独自設定ファイルの場所
fpath=(~/.zsh/functions/Completion ${fpath})
# コマンド補完の必須設定
autoload -Uz compinit
compinit
# 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1
# zsh editor
autoload zed
# コマンド履歴からの入力候補表示
#autoload predict-on
#predict-off

# 常に最後の行のみ右プロンプト表示
setopt transient_rprompt

# ターミナル設定
case "${TERM}" in
screen)
    TERM=xterm
    ;;
esac

# ターミナルの違いによるカラー表示設定
# lsコマンドと補完候補のカラー同期
case "$OSTYPE" in
darwin*)
    OSVER="$OSTYPE"
    ;;
linux-gnu*)
    OSVER=`cat /etc/issue | head -1 | awk '{print $3}'`
    ;;
esac

case "${TERM}" in
xterm|xterm-color)
    # RHLE(CentOS)の5/6系で分ける
    case "${OSVER}" in
    5\.*)
        export LSCOLORS=exfxcxdxbxegedabagacad
        export LS_COLORS='no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:'
        zstyle ':completion:*' list-colors 'no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:'
        ;;
    6\.*|darwin*)
        export LSCOLORS=gxfxcxdxbxegedabagacad
        export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.tbz=01;31:*.tbz2=01;31:*.bz=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:'
        zstyle ':completion:*' list-colors 'rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.tbz=01;31:*.tbz2=01;31:*.bz=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:'        ;;
    esac
    ;;
kterm-color)
    stty erase '^H'
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
kterm)
    stty erase '^H'
    ;;
cons25)
    unset LANG
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
jfbterm-color)
    export LSCOLORS=gxFxCxdxBxegedabagacad
    export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' list-colors 'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    ;;
esac

# ターミナルのタイトル表示
case "${TERM}" in
kterm*|xterm*)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

# ユーザ独自の追加設定があれば読み込む
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

