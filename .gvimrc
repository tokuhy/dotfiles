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
highlight CursorLine cterm=NONE guibg=NONE ctermbg=233 guibg=gray10
highlight CursorColumn cterm=NONE guibg=NONE ctermbg=233 guibg=gray10
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
" ウインドウの幅
set columns=110
" ウインドウの高さ
set lines=45
" 自動改行無効
set formatoptions=q
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
" タイトルを表示
set title
" pasteモードの切り替え
set pastetoggle=<F12>

"" キーバインド
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

"" 以下OS依存
" Windows
if has('win32')
    " .gvimrcの再読み込み
    nnoremap <Space>.   :<C-u>source $HOME\.gvimrc<CR>
    " フォント設定
    set guifont=Migu_1M:h12:cSHIFTJIS
    " バックアップファイルの作成場所
    set backupdir=C:\vim_tmp
    " スワップファイルの作成場所
    set directory=C:\vim_tmp
    " 自動的にファイルを読み込むパスを設定 ~/vimfiles/userautoload/*.vim
    set runtimepath+=~/vimfiles/
    runtime! userautoload/*.vim
elseif has('mac')
    " バックアップファイルの作成場所
    set backupdir=~/vim_tmp
    " スワップファイルの作成場所
    set directory=~/vim_tmp
endif
