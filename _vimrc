" vim:set ts=4 sts=4 sw=4 tw=0 ft=vim:

"初期処理----------
" mapの初期化
mapclear
mapclear!

" WindowsやMacを判断する
let s:chk_win = has('win32') || has('win64')
let s:chk_mac = !s:chk_win && (has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin')

" Windows/Linux,Macにおいて、.vimとvimfilesの違いを吸収する
if s:chk_win
    let $DOTVIM = $HOME . '/vimfiles'
else
    let $DOTVIM = $HOME . '/.vim'
endif
" Vimで利用するOS依存一時ファイルの場所を指定
let $MISCVIM = $HOME . '/misc'

"初期設定----------
" <Space>.で即座にvimrcを開けるようにする
nnoremap <Space>. :<C-u>edit $MYVIMRC<CR>

" ファイルタイプの検出、ファイルタイププラグインを使う、インデントファイルを使う
filetype plugin indent on
" 構文強調表示を有効にする
syntax enable
set hlsearch
" ヘルプドキュメントに利用する言語
set helplang=ja,en
set notagbsearch

"日本語用エンコード設定----------
set fileencodings=ucs-bom,utf-8,iso-2022-jp,cp932,euc-jp,cp20932
set fileformats=unix,dos,mac

"GUI固有ではない画面表示の設定----------
colorscheme miku

" ウィンドウのタイトルの表示
set title
" ステータスラインの表示
let g:ff_table = {'dos' : 'CR+LF', 'unix' : 'LF', 'mac' : 'CR' }
set statusline=%<%{expand('%:p')}\ %m%r%h%w%=[%{(&fenc!=''?&fenc:&enc)}:%{g:ff_table[&ff]}][%{&ft}](%l/%L)[%{tabpagenr()}/%{tabpagenr('$')}]
" タブページのラベルの表示
set showtabline=0
" ステータス行の表示
set laststatus=2
" ステータス行の高さ
set cmdheight=1
" コマンドの画面最下行への表示
set showcmd
" コマンドラインにメッセージが表示される閾値
set report=0

" GUI
" ビープ音にビジュアルベルの使用
set visualbell
" バックスペースの設定
set backspace=2
" 非表示文字
" タブ文字や行末の表示
set list
" タブ文字や行末に表示する文字の指定
set listchars=tab:>_,trail:~,eol:$

" misc
" マルチバイト文字の幅の扱いの指定
set ambiwidth=double
" 行連結コマンドにおいての空白挿入の設定
set nojoinspaces

" 挿入モードでのIMEの状態の設定
set iminsert=0
set imsearch=-1

"編集に関する設定----------
" インデント
" 新しい行を開始したときに新しい行のインデントの設定
set autoindent
set smartindent
" Insertモードでタブ文字を挿入するときの空白の設定
set noexpandtab
set smarttab
set tabstop=8
set softtabstop=8
set shiftwidth=8
" インデントをshiftwidthの値の整数倍にまとめる設定
set shiftround

" テキストの自動改行の設定
set textwidth=0

" 矩形選択で自由に範囲を移動する
set virtualedit& virtualedit+=block

" 補完
" キーワード補完の設定
set complete=.,w,b,u,k
" 補完のプレビューの設定
set completeopt=menuone
" コマンドライン補完の設定
set wildmenu
set wildmode=full
set wildchar=<Tab>
" Insertモード補完のポップアップに表示される項目数の最大値
set pumheight=8

" 自動補完の設定
if !exists('MyAutoComplete_StartLength')
    let MyAutoComplete_StartLength = 3
endif
if !exists('MyAutoComplete_cmd')
    let MyAutoComplete_cmd = "\<C-n>\<C-p>"
endif
" 補完が発動するキー
function! s:AutoCompletionRegKeys(s, e)
    let letter = a:s
    while letter <=# a:e
        execute 'inoremap <silent> <expr> ' letter ' "' . letter . '" . <SID>AutoCompletion()'
        let letter = nr2char(char2nr(letter)+1)
    endwhile
endfunction
call s:AutoCompletionRegKeys('0', '9')
call s:AutoCompletionRegKeys('a', 'z')
call s:AutoCompletionRegKeys('A', 'Z')
execute 'inoremap <silent> <expr> _ "_" . <SID>AutoCompletion()'
" 自動補完
let s:accnt  = 0
let s:accol  = col('.')
let s:acline = line('.')
function! s:AutoCompletion()
    if s:acline != line('.') || col('.') > s:accol + 1
        let s:accnt  = 0
        let s:accol  = col('.')
        let s:acline = line('.')
        return ''
    endif
    let s:accnt = s:accnt - (s:accol - col('.'))
    if s:accnt < 0
        let s:accnt = 0
    endif
    let s:accol  = col('.')
    let s:acline = line('.')
    if s:accnt+1 >= g:MyAutoComplete_StartLength
        if !pumvisible()
            return g:MyAutoComplete_cmd
        endif
    endif
    return ''
endfunction

"Sticky Shift
inoremap <expr> ; <SID>sticky_func()
cnoremap <expr> ; <SID>sticky_func()
snoremap <expr> ; <SID>sticky_func()
function! s:sticky_func()
    let l:special_table = {"\<ESC>" : "\<ESC>", "\<Space>" : ';', "\<CR>" : ";\<CR>"}
    let l:key = getchar()
    if nr2char(l:key) =~ '\l'
        return toupper(nr2char(l:key))
    elseif has_key(l:special_table, nr2char(l:key))
        return l:special_table[nr2char(l:key)]
    else
        return nr2char(l:key)
    endif
endfunction

" スワップファイルの設定
set swapfile
" バックアップファイルの設定
set nobackup
set backupdir=$MISCVIM/tmp/backup
" 巻き戻しの設定
set undofile
set undodir=$MISCVIM/tmp/undo
" vimfinfo
set viminfo='16,<50,s10,h,rA:,rB:,n$MISCVIM/tmp/_viminfo

" misc
" バッファを放棄したときのファイルの開放の設定
set hidden
" 数の増減に関する設定
set nrformats& nrformats=hex
" クリップボードに利用するレジスタの設定
set clipboard& clipboard+=unnamed,autoselect

"検索に関する設定----------
" インクリメンタルサーチ
set incsearch
" 大文字を含んでいた場合の設定
set ignorecase
set smartcase
" <Space>の2回押しでハイライト消去
nnoremap <silent> <Space><Space> :<C-u>nohlsearch<CR><ESC>

"マップ定義 - Normalモード----------
" ウィンドウ分割の方向
set splitbelow
set splitright
" デフォルトの最小ウィンドウの高さ
set winminheight=0
" <C-w><Space>または<Tab>で次のウィンドウに移動する
nnoremap <C-w><Space> <C-w>w
nnoremap <Tab> <C-w>w

" Hで前のバッファを表示
nnoremap H :<C-u>bprevious<CR>
" Lで次のバッファを表示
nnoremap L :<C-u>bnext<CR>

"マップ定義 - Visualモード----------

"マップ定義 - Insertモード----------
" ]を入力した際に、対応する括弧が見つからない場合は補完キーとする
inoremap <silent> <expr> ] searchpair('\[', '', '\]', 'nbW', 'synIDattr(synID(line("."), col("."), 1), "name") =~? "String"') ? ']' : "\<C-n>"

"マップ定義 - Command-lineモード----------

"Plug-in用設定----------
" ctrlp用設定
let g:ctrlp_cache_dir       = $MISCVIM . '/tmp/ctrlp/'
let g:ctrlp_use_caching     = 1
let g:ctrlp_max_files       = 1024
let g:ctrlp_max_depth       = 5


set secure
