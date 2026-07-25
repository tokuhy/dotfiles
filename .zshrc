# 言語設定: 環境が LANG を設定済みならそれを尊重し、未設定ならチーム既定の日本語にフォールバック
# （非日本語ユーザーはターミナル/OS のロケールがそのまま生きる。明示上書きは ~/.zshrc.mine で）
export LANG="${LANG:-ja_JP.UTF-8}"
# 環境設定
export PAGER=less
# npm: 共有ハードニング設定を globalconfig として読み込む（個人/token は ~/.npmrc に分離）
[ -f ~/.config/npm/npmrc ] && export NPM_CONFIG_GLOBALCONFIG="$HOME/.config/npm/npmrc"

# Homebrew: PATH/MANPATH等を設定
# brewのフルパスで呼ぶのでPATHが未通でも動く（type brewのチェックより確実）
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"   # Apple Silicon
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"      # Intel
fi

# zsh-completions（brewが使えるとき）
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"
fi

#path=xxxx(N-/)
#  (N-/): 存在しないディレクトリは登録しない
#  パス(...): ...という条件にマッチするパスのみ残す
#     N: NULL_GLOBオプションを設定。
#        globがマッチしなかったり存在しないパスを無視する
#     -: シンボリックリンク先のパスを評価
#     /: ディレクトリのみ残す
#     .: 通常のファイルのみ残す

# 存在するディレクトリだけ PATH に追加する（(N-/) で不在ディレクトリは登録しない）
path=(
    ~/bin(N-/)         # 個人スクリプト
    ~/.local/bin(N-/)  # claude
    $path
)

# gcloud（Homebrew cask gcloud-cli）: components 由来の追加バイナリ（gcloud-crc32c 等）用。
# gcloud / bq / gsutil 本体は /opt/homebrew/bin の symlink を正とするので末尾に足す
path+=(/opt/homebrew/share/google-cloud-sdk/bin(N-/))

# 初期化に eval / source が必要なものはディレクトリの有無でガードする
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
# nvm環境があれば実行
if [ -d $HOME/.nvm ];then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi


# 重複したPATHを除外する
# PATH 設定の前に持ってくるとうまく動かないのでここに
typeset -U path cdpath fpath manpath

# editor: neovim があれば優先、無ければ vim にフォールバック
if type nvim &>/dev/null; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi

## alias設定

alias where="command -v"
alias j="jobs -l"
# OSの違いによる設定
case "${OSTYPE}" in
darwin*)
    alias ls="ls -G -w"
    alias grep="grep --color=auto"
    ;;
linux*)
    alias ls="ls --color=always"
    alias grep="grep --color=auto"
    ;;
esac

alias la="ls -al"
alias lf="ls -F"
alias ll="ls -l"
alias du="du -h"
alias df="df -h"
# vi/vim は解決済みの $EDITOR（nvim か vim）を指す
alias vi="$EDITOR"
alias vim="$EDITOR"
alias less="less -R"
alias g="git "
alias be="bundle exec"

# sudo のエイリアス対応
alias sudo="sudo "
# tmux 256色対応
alias tmux="tmux -2"

case "${OSTYPE}" in
darwin*)
    alias tm="tmuxx"
    alias tma="tmux attach"
    alias tml="tmux list-window"
    ;;
esac

# 上書き/削除の確認系（確認プロンプト）。手動実行では安全網として効かせ、
# Claude Code 実行時（CLAUDECODE=1）は無効化し自動処理が止まらないようにする
if [[ -z "$CLAUDECODE" ]]; then
    alias rm="rm -i"
    alias cp="cp -i"
    alias mv="mv -i"
fi

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
zstyle ':completion:*:sudo:*' command-path /opt/homebrew/bin /opt/homebrew/sbin /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
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
# 履歴の共有（即時追記＋他シェルからの取り込みを含むため inc_append_history は不要）
setopt share_history
# 余分な空白は詰める
setopt hist_reduce_blanks

# 補完機能
# コマンド補完の必須設定（1日1回だけ ~/.zcompdump を再生成し、以降は高速スキップ）
# -i: insecure directories（group-writable な Homebrew completion 等）を警告/プロンプトせず無視する
autoload -Uz compinit
if [ "$(date +%j)" != "$(date -r ~/.zcompdump +%j 2>/dev/null)" ]; then
    compinit -i
else
    compinit -C
fi
# 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1

# gcloud 補完（Homebrew cask gcloud-cli）
# completion.zsh.inc は #compdef を持たず bashcompinit で complete -F 登録する形式のため、
# fpath に置いても compinit のスキャンでは拾われない。compinit の後に明示的に source する
[ -f /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc ] \
    && . /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc
# zsh editor
autoload zed

# 常に最後の行のみ右プロンプト表示
setopt transient_rprompt

# ls / 補完候補のカラー設定
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='rs=0:di=01;36:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.tbz=01;31:*.tbz2=01;31:*.bz=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.axa=01;36:*.oga=01;36:*.spx=01;36:*.xspf=01;36:'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ターミナルのタイトル表示
case "${TERM}" in
xterm*|screen*)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

# ユーザ独自の追加設定があれば読み込む
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine
