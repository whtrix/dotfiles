"初期処理----------
" mapの初期化
mapclear
mapclear!

" WindowsやMacを判断する
let s:chk_win = has('win32') || has('win64')
let s:chk_mac = !s:chk_win && (has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin')

" Windows/Linux,Macにおいて、.vimとvimfilesの違いを吸収する
if s:chk_win
    let $DOTVIM = $HOME .. '/vimfiles'
else
    let $DOTVIM = $HOME .. '/.vim'
endif
" Vimで利用するOS依存一時ファイルの場所を指定
let $MISCVIM = $HOME .. '/misc'

"初期設定----------
" <Space>をLeaderに設定する
let mapleader = "\<Space>"
" <Leader>.で即座にvimrcを開けるようにする
nnoremap <Leader>. :<C-u>edit $MYVIMRC<CR>

" TrueColorの有効化
set termguicolors

" 構文強調表示に関する設定
syntax enable
" ファイルタイプ、ファイルタイププラグイン、インデントファイルの設定
filetype plugin indent on
" 検索文字列強調表示に関する設定
set hlsearch
" ヘルプドキュメントに利用する言語
set helplang=ja,en
set notagbsearch

" 日本語用エンコード設定
set fileencodings=ucs-bom,utf-8,iso-2022-jp,cp932,euc-jp,cp20932
set fileformats=unix,dos,mac

" スペルチェック設定
set spelllang=en,cjk

"GUI固有ではない画面表示の設定----------
colorscheme solarized

" ウィンドウのタイトルの表示
set title
" ステータスラインの表示
let g:ff_table = {'dos' : 'dos:CR+LF', 'unix' : 'unix:LF', 'mac' : 'mac:CR' }
set statusline=%<%{expand('%:p')}\ %m%r%h%w%=[%{(&fenc!=''?&fenc:&enc)}\|%{g:ff_table[&ff]}][%{&ft}](%l/%L)[%{tabpagenr()}/%{tabpagenr('$')}]
highlight StatusLine term=reverse cterm=reverse
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
" 開いているファイルのディレクトリに移動する
set autochdir
" 検索位置が何番目なのかわかるようにする
set shortmess-=S

" GUI
" ビープ音にビジュアルベルの使用
set visualbell
" バックスペースの設定
set backspace=indent,eol,start
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
" 矩形選択で自由に範囲を移動する
set virtualedit& virtualedit+=block

" 補完
set complete=.,w,b,u,t
set completeslash=slash
" 補完のプレビューの設定
set completeopt=menuone,preview
" コマンドライン補完の設定
set wildmenu
set wildmode=full
set wildchar=<Tab>
" Insertモード補完のポップアップに表示される項目数の最大値
set pumheight=8

" 自動補完の設定
if !exists('g:MyAutoComplete_StartLength')
    let g:MyAutoComplete_StartLength = 3
endif
if !exists('g:MyAutoComplete_cmd')
    let g:MyAutoComplete_cmd = "\<C-n>\<C-p>"
endif
" 補完が発動するキー
function! s:AutoCompletionRegKeys(s, e)
    let l:letter = a:s
    while l:letter <=# a:e
        execute 'inoremap <silent> <expr> ' l:letter ' "' .. l:letter .. '" .. <SID>AutoCompletion()'
        let l:letter = nr2char(char2nr(l:letter)+1)
    endwhile
endfunction
call s:AutoCompletionRegKeys('0', '9')
call s:AutoCompletionRegKeys('a', 'z')
call s:AutoCompletionRegKeys('A', 'Z')
execute 'inoremap <silent> <expr> _ "_" .. <SID>AutoCompletion()'
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

" Quickfix/Locationlistの表示
nnoremap <silent> <Plug>(my-toggle-quickfix) :<C-u>call <SID>toggle_qf()<CR>
nmap Q <Plug>(my-toggle-quickfix)
function! s:toggle_qf() abort
    let l:nwin = winnr('$')
    cclose
    if l:nwin == winnr('$')
        botright copen
    endif
endfunction

nnoremap <silent> <Plug>(my-toggle-locationlist) :<C-u>call <SID>toggle_ll()<CR>
nmap L <Plug>(my-toggle-locationlist)
function! s:toggle_ll() abort
    try
        let l:nwin = winnr('$')
        lclose
        if l:nwin == winnr('$')
            botright lopen
        endif
    catch /^Vim\%((\a\+)\)\=:E776/
        echohl WarningMsg
        redraw | echo 'No location list'
        echohl None
    endtry
endfunction

" スワップファイルの設定
set swapfile
" バックアップファイルの設定
set backup
set backupdir=$MISCVIM/vim/backup
" 巻き戻しの設定
set undofile
set undodir=$MISCVIM/vim/undo
" vimfinfo
if s:chk_win
    set viminfo='16,<50,s10,h,rA:,rB:,n$MISCVIM/vim/_viminfo
else
    set viminfo='16,<50,s10,h,rA:,rB:,n$MISCVIM/vim/.viminfo
endif

" misc
" バッファを放棄したときのファイルの開放の設定
set hidden
" 数の増減に関する設定
set nrformats& nrformats=hex
" クリップボードに利用するレジスタの設定
set clipboard& clipboard^=unnamedplus

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
" <Tab>または<C-w><Space>で次のウィンドウに移動する
nnoremap <Tab> <C-w>w
nnoremap <C-w><Space> <C-w>w
" <C-w>zで現在のバッファを最大化する
nnoremap <silent> <Plug>(my-zoom-window) :<C-u>call <SID>toggle_window_zoom()<CR>
nmap <C-w>z <Plug>(my-zoom-window)
function! s:toggle_window_zoom() abort
    if exists('t:zoom_winrestcmd')
        execute t:zoom_winrestcmd
        unlet t:zoom_winrestcmd
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
    endif
endfunction

" <C-h>で前のバッファを表示
nnoremap <C-h> :<C-u>bprevious<CR>
" <C-l>で次のバッファを表示
nnoremap <C-l> :<C-u>bnext<CR>

" ]を入力した際に、対応する括弧が見つからない場合は補完キーとする
inoremap <silent> <expr> ] searchpair('\[', '', '\]', 'nbW', 'synIDattr(synID(line("."), col("."), 1), "name") =~? "String"') ? ']' : "\<C-n>"

"FileType別設定----------
augroup MyFileType
    autocmd!
    autocmd FileType * execute printf("setlocal dict=$DOTVIM/dict/%s.dict", &filetype)
augroup END

"Plugin別設定----------
" Netrw
let g:netrw_home=$MISCVIM .. '/vim/netrw'

set secure

" vim:set ts=4 sts=4 sw=4 tw=0 ft=vim:
