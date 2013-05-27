"""""""""""""""""
" プラグイン管理
"""""""""""""""""
set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim

  call neobundle#rc(expand('~/.vim/bundle/'))
endif

"" github
"NeoBundle 'Shougo/clang_complete.git'
"NeoBundle 'Shougo/echodoc.git'
NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/neobundle.vim.git'
NeoBundle 'Shougo/unite.vim.git'
"NeoBundle 'Shougo/vim-vcs.git'
"NeoBundle 'Shougo/vimfiler.git'
"NeoBundle 'Shougo/vimshell.git'
"NeoBundle 'Shougo/vinarise.git'

"" vim-scripts
NeoBundle 'project.tar.gz'
NeoBundle 'sudo.vim'
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'Markdown'

"" syntax
" nginx
NeoBundle 'nginx.vim'

"""""""""
" syntax
"""""""""
au BufRead,BufNewFile /etc/nginx/*,nginx.conf setf nginx

filetype plugin on
filetype indent on

"""""""""""""""""
" 文字コード判定
"""""""""""""""""
" 文字コードの自動認識
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif
if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
    " iconvがeucJP-msに対応しているかをチェック
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
    " iconvがJISX0213に対応しているかをチェック
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
    " fileencodingsを構築
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','. s:fileencodings_default
        unlet s:fileencodings_default
    else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
        else
            let &fileencodings = &fileencodings .','. s:enc_euc
        endif
    endif
    " 定数を処分
    unlet s:enc_euc
    unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
    function! AU_ReCheck_FENC()
       if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
       endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endi
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
    set ambiwidth=double
endif

"""""""""""
" 追加設定
"""""""""""
" 256色設定
set t_Co=256
" カラー設定
syntax on
colorscheme desert256
" カーソルラインの強調表示を有効化
set cursorline
set cursorcolumn
" カーソルラインカラー
highlight CursorLine cterm=NONE guibg=NONE ctermbg=234 guibg=gray10
highlight CursorColumn cterm=NONE guibg=NONE ctermbg=234 guibg=gray10
" タブ文字、行末など不可視文字を表示する
set list
" listで表示される文字のフォーマットを指定する
set listchars=tab:^\ ,trail:~,nbsp:%,extends:>,precedes:<
" 全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/
" 長い行を折り返す
set wrap

" [Backspace] で既存の文字を削除できるように設定
"  start - 既存の文字を削除できるように設定
"  eol - 行頭で[Backspace]を使用した場合上の行と連結
"  indent - オートインデントモードでインデントを削除できるように設定
set backspace=indent,eol,start
" Vi互換をオフ
set nocompatible
" 新しい行のインデントを現在行と同じにする
set autoindent
" 新しい行を作ったときに高度な自動インデントを行う
set smartindent
" カーソルを行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" シフト移動幅
set shiftwidth=4
" 変更中のファイルでも、保存しないで他のファイルを表示
set hidden
" 検索結果ハイライト
set hlsearch
" 行番号表示
set number
" インクリメンタルサーチ
set incsearch
" 検索時に大文字小文字を区別しない
set ic
" ↑但し検索文字列に大文字が入っている場合は区別する
set smartcase
" 半角と全角の対応
set ambiwidth=double
" Tabキーの幅
set tabstop=4
" Tabキー入力を半角スペースで展開する
set expandtab
" 対応するカッコの強調表示無効
let loaded_matchparen = 1
" 整形オプション，マルチバイト系を追加
set formatoptions+=m
" マウスを有効化
set mouse=a
set ttymouse=xterm2
" コマンド補完を強化 リスト表示，最長マッチ
set wildmenu wildmode=list:full
" 改行コードの自動認識
set fileformats=unix,dos,mac
" 常にタブ表示
set showtabline=2
" タイトルを表示
set title
" 開始時デフォルトはpaste mode
set paste
" pasteモードの切り替え
set pastetoggle=<F12>

" ステータスラインの設定
" 0:表示しない 1:ウインドウが2つ以上の場合のみ 2:常に表示
set laststatus=2
" 編集中のファイル/文字コード/改行コード/ファイルタイプ/行番号,列番号,行数,位置%/カーソル位置にあるキャラクタのASCII/16進値
set statusline=%F%m%r%h%w\ %=[FMT=%{&ff}]\ [ENC=%{&fileencoding}]\ [TYPE=%Y]\ [POS=%05l,%03v,%05L,%p%%]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]
"set statusline=%F%r%h%=%p
" コマンドラインの高さ
set cmdheight=2
" コマンドをステータス行に表示
set showcmd

" 折りたたみ
set foldmethod=marker

"""""""""""""""
" キーバインド
"""""""""""""""
" バッファファイルの逆切り替え
nmap    <C-p>       <ESC>:bp<CR>
map     <F2>        <ESC>:bp<CR>
map     <space>p    <ESC>:bp<CR>
" バッファファイルの順切り替え
nmap    <C-n>       <ESC>:bn<CR>
map     <F3>        <ESC>:bn<CR>
map     <space>n    <ESC>:bn<CR>
" 開いているファイルの終了
map     <F4>        <ESC>:bd<CR>
map     <space>w    <ESC>:bd<CR>
" 検索結果ハイライト解除
nmap    <ESC><ESC>  :nohlsearch<CR>
" 行番号表示切り替え
map     <F10>       :set number!<CR>

"""""""""""""""
" コマンド実行
"""""""""""""""
" 保存時に行末の空白を除去する。ただしMarkdownファイルは除外。
autocmd BufWritePre * if  &ft!='markdown' | :%s/\s\+$//ge
" シェルスクリプト用のテンプレート
autocmd BufNewFile *.sh 0r $HOME/dotfiles/.vim/templates/sh.txt
autocmd BufNewFile *.md 0r $HOME/dotfiles/.vim/templates/markdown.txt

" 行番号と相対行番号の切替
if version >= 703
  nnoremap   <F11> :<C-u>ToggleNumber<CR>
  command! -nargs=0 ToggleNumber call ToggleNumberOption()

  function! ToggleNumberOption()
    if &number
      set relativenumber
    else
      set number
    endif
  endfunction
endif

"""""""""
" OS依存
"""""""""
" Windows
if has('win32')
    " _gvimrcの再読み込み
    nnoremap <Space>.   :<C-u>source $VIM\_gvimrc<CR>
    " フォント設定
    set guifont=Migu_1M:h12:cSHIFTJIS
    " 自動改行無効
    set formatoptions=q
    " ウインドウの幅
    set columns=110
    " ウインドウの高さ
    set lines=45
    " 自動的にファイルを読み込むパスを設定 ~/vimfiles/userautoload/*.vim
    set runtimepath+=~/vimfiles/
    runtime! userautoload/*.vim
elseif has('mac')
    " フォント設定
    set guifont=Ricty_for_Powerline:h16
    set guifontwide=Ricty:h16
    let g:Powerline_symbols = 'fancy'
    " バックアップファイルの作成場所
    set backupdir=~/vim_tmp
    " スワップファイルの作成場所
    set directory=~/vim_tmp
endif

