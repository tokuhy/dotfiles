-- neovim 設定（旧 .vimrc の素設定を移植。プラグインは使わない）

local opt = vim.opt
local g = vim.g

-----------------------------------------------------------
-- 文字コード（neovim は UTF-8 native。旧 .vimrc の iconv 分岐は簡略化）
-----------------------------------------------------------
opt.fileencodings = { "utf-8", "iso-2022-jp", "euc-jp", "cp932" }
opt.fileformats = { "unix", "dos", "mac" }
-- □ ○ などの全角あいまい幅文字でカーソル位置がずれないように
opt.ambiwidth = "double"

-----------------------------------------------------------
-- 表示
-----------------------------------------------------------
vim.cmd("syntax on")
-- desert は neovim 同梱の配色
pcall(vim.cmd.colorscheme, "desert")

opt.cursorline = true
opt.cursorcolumn = true
opt.list = true
opt.listchars = { tab = "^ ", trail = "~", nbsp = "%", extends = ">", precedes = "<" }
opt.wrap = true

-- カーソルライン/カラムの色（旧 .vimrc の ctermbg=234 を再現）
local function apply_highlights()
    vim.api.nvim_set_hl(0, "CursorLine", { ctermbg = 234, bg = "gray10" })
    vim.api.nvim_set_hl(0, "CursorColumn", { ctermbg = 234, bg = "gray10" })
    -- 全角スペースを可視化
    vim.api.nvim_set_hl(0, "ZenkakuSpace", { cterm = { underline = true }, ctermfg = "lightblue", bg = "#666666" })
end
apply_highlights()
-- colorscheme 読み込みでハイライトが上書きされても再適用する
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "*", callback = apply_highlights })
-- 全角スペースにマッチさせる
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*",
    callback = function()
        vim.fn.matchadd("ZenkakuSpace", "　")
    end,
})

-----------------------------------------------------------
-- 編集・インデント
-----------------------------------------------------------
opt.backspace = { "indent", "eol", "start" }
opt.autoindent = true
opt.smartindent = true
opt.whichwrap = "b,s,h,l,<,>,[,]"
opt.hidden = true
opt.hlsearch = true
opt.number = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.formatoptions:append("m")
opt.foldmethod = "marker"
-- 対応カッコの強調を無効化
g.loaded_matchparen = 1

-----------------------------------------------------------
-- UI
-----------------------------------------------------------
opt.mouse = "a"
opt.wildmenu = true
opt.wildmode = "list:full"
opt.showtabline = 2
opt.title = true
opt.laststatus = 2
opt.cmdheight = 2
opt.showcmd = true
-- ステータスライン（旧 .vimrc の定義をそのまま流用）
opt.statusline = "%F%m%r%h%w %=[FMT=%{&ff}] [ENC=%{&fileencoding}] [TYPE=%Y] [POS=%05l,%03v,%05L,%p%%] [ASCII=\\%03.3b] [HEX=\\%02.2B]"

-----------------------------------------------------------
-- キーマップ
-----------------------------------------------------------
local map = vim.keymap.set
-- バッファの逆切り替え
map("n", "<C-p>", "<ESC>:bp<CR>")
map("", "<F2>", "<ESC>:bp<CR>")
map("", "<space>p", "<ESC>:bp<CR>")
-- バッファの順切り替え
map("n", "<C-n>", "<ESC>:bn<CR>")
map("", "<F3>", "<ESC>:bn<CR>")
map("", "<space>n", "<ESC>:bn<CR>")
-- 開いているファイルを閉じる
map("", "<F4>", "<ESC>:bd<CR>")
map("", "<space>w", "<ESC>:bd<CR>")
-- 検索ハイライト解除
map("n", "<ESC><ESC>", ":nohlsearch<CR>")
-- 行番号表示トグル
map("", "<F10>", ":set number!<CR>")
