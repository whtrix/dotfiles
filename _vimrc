" vim:set ts=4 sts=4 sw=4 tw=0 ft=vim:

"��������----------
" map�̏�����
mapclear
mapclear!
" augroup�̏�����
augroup vimrc
    autocmd!
augroup END
" autocmd�̊ȗ���
command! -bang -nargs=* AutoCommand autocmd<bang> vimrc <args>

" Windows��Mac�𔻒f����
let s:chk_win = has('win32') || has('win64')
let s:chk_mac = !s:chk_win && (has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin')

" Windows/Linux,Mac�ɂ����āA.vim��vimfiles�̈Ⴂ���z������
if s:chk_win
    let $DOTVIM = $HOME . '/vimfiles'
else
    let $DOTVIM = $HOME . '/.vim'
endif
" Vim�ŗ��p����OS�ˑ��ꎞ�t�@�C���̏ꏊ���w��
let $MISCVIM = $HOME . '/misc'

"�����ݒ�----------
" <Space>.�ő�����vimrc���J����悤�ɂ���
nnoremap <Space>. :<C-u>edit $MYVIMRC<CR>

" �e��v���O�C���̃��[�h
filetype plugin indent off
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
" �t�@�C���^�C�v�̌��o�A�t�@�C���^�C�v�v���O�C�����g���A�C���f���g�t�@�C�����g��
filetype plugin indent on
" �w���v�h�L�������g�ɗ��p���錾��
set helplang=ja,en
set notagbsearch

"���{��p�G���R�[�h�ݒ�----------
set fileencodings=ucs-bom,utf-8,iso-2022-jp,cp932,euc-jp,cp20932
set fileformats=unix,dos,mac

"GUI�ŗL�ł͂Ȃ���ʕ\���̐ݒ�----------
colorscheme koehler
" �\�������\����L���ɂ���
syntax enable
set hlsearch

" �E�B���h�E�̃^�C�g���̕\��
set title
" �X�e�[�^�X���C���̕\��
let g:ff_table = {'dos' : 'CR+LF', 'unix' : 'LF', 'mac' : 'CR' }
set statusline=%<%{expand('%:p')}\ %m%r%h%w%=[%{(&fenc!=''?&fenc:&enc)}:%{g:ff_table[&ff]}][%{&ft}](%l/%L)[%{tabpagenr()}/%{tabpagenr('$')}]
" �^�u�y�[�W�̃��x���̕\��
set showtabline=0
" �X�e�[�^�X�s�̕\��
set laststatus=2
" �X�e�[�^�X�s�̍���
set cmdheight=1
" �R�}���h�̉�ʍŉ��s�ւ̕\��
set showcmd
" �R�}���h���C���Ƀ��b�Z�[�W���\�������臒l
set report=0

" GUI
" �r�[�v���Ƀr�W���A���x���̎g�p
set visualbell
" �o�b�N�X�y�[�X�̐ݒ�
set backspace=2
" ��\������
" �^�u������s���̕\��
set list
" �^�u������s���ɕ\�����镶���̎w��
set listchars=tab:>_,trail:~

" �X�N���[��
" <C-f>�A<C-b>�ŃX���[�X�X�N���[��������
let g:scroll_factor = 5000
let g:scroll_skip_line_size = 3
noremap <C-f> :call SmoothScroll("f",1, 1)<CR>
noremap <C-b> :call SmoothScroll("b",1, 1)<CR>
function! SmoothScroll(dir, windiv, factor)
    let wh=winheight(0)
    let i=0
    let j=0
    while i < wh / a:windiv
        let t1=reltime()
        let i = i + 1
        if a:dir=="f"
            if line('w$') == line('$')
                break
            endif
            exec "normal \<C-E>j"
        else
            if line('w0') == 1
                break
            endif
            exec "normal \<C-Y>k"
        endif
        if j >= g:scroll_skip_line_size
            let j = 0
            redraw
            while 1
                let t2=reltime(t1,reltime())
                if t2[1] > g:scroll_factor * a:factor
                    break
                endif
            endwhile
        else
            let j = j + 1
        endif
    endwhile
endfunction

" misc
" �}���`�o�C�g�����̕��̈����̎w��
set ambiwidth=double
" �s�A���R�}���h�ɂ����Ă̋󔒑}���̐ݒ�
set nojoinspaces

" �}�����[�h�ł�IME�̏�Ԃ̐ݒ�
set iminsert=0
set imsearch=-1

"�ҏW�Ɋւ���ݒ�----------
" �C���f���g
" �V�����s���J�n�����Ƃ��ɐV�����s�̃C���f���g�̐ݒ�
set autoindent
set smartindent
" Insert���[�h�Ń^�u������}������Ƃ��̋󔒂̐ݒ�
set noexpandtab
set smarttab
set tabstop=8
set softtabstop=8
set shiftwidth=8
" �C���f���g��shiftwidth�̒l�̐����{�ɂ܂Ƃ߂�ݒ�
set shiftround

" �e�L�X�g�̎������s�̐ݒ�
set textwidth=0

" ��`�I���Ŏ��R�ɔ͈͂��ړ�����
set virtualedit& virtualedit+=block

" �⊮
" �L�[���[�h�⊮�̐ݒ�
set complete=.,w,b,u,k
AutoCommand FileType * execute printf("setlocal dict=$DOTVIM/dict/%s.dict", &filetype)
" �⊮�̃v���r���[�̐ݒ�
set completeopt=menuone
" �R�}���h���C���⊮�̐ݒ�
set wildmenu
set wildmode=full
set wildchar=<Tab>
" Insert���[�h�⊮�̃|�b�v�A�b�v�ɕ\������鍀�ڐ��̍ő�l
set pumheight=8

" �����⊮�̐ݒ�
if !exists('MyAutoComplete_StartLength')
    let MyAutoComplete_StartLength = 3
endif
if !exists('MyAutoComplete_cmd')
    let MyAutoComplete_cmd = "\<C-n>\<C-p>"
endif
" �⊮����������L�[
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
" �����⊮
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

" �X���b�v�t�@�C���̐ݒ�
set swapfile
" �o�b�N�A�b�v�t�@�C���̐ݒ�
set nobackup
set backupdir=$MISCVIM/tmp/backup
" �����߂��̐ݒ�
set undofile
set undodir=$MISCVIM/tmp/undo
" vimfinfo
set viminfo='16,<50,s10,h,rA:,rB:,n$MISCVIM/tmp/_viminfo

" misc
" �o�b�t�@����������Ƃ��̃t�@�C���̊J���̐ݒ�
set hidden
" ���̑����Ɋւ���ݒ�
set nrformats& nrformats=hex
" �N���b�v�{�[�h�ɗ��p���郌�W�X�^�̐ݒ�
set clipboard& clipboard+=unnamed,autoselect

" �J�����g�f�B���N�g�����t�@�C���Ɠ����f�B���N�g���Ɉړ�
AutoCommand BufEnter * execute 'silent! lcd ' . escape(expand("%:p:h"), ' ')

" �g���̂ėp�̃t�@�C���̐���
nnoremap <Space>j :<C-u>JunkFile<CR>
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
    let l:junk_dir = $MISCVIM . '/junk'
    if !isdirectory(l:junk_dir)
        call mkdir(l:junk_dir, 'p')
    endif
    let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d'))
    if l:filename != ''
        execute 'edit ' . l:filename
    endif
endfunction

"�����Ɋւ���ݒ�----------
" �C���N�������^���T�[�`
set incsearch
" �啶�����܂�ł����ꍇ�̐ݒ�
set ignorecase
set smartcase
" <Space>��2�񉟂��Ńn�C���C�g����
nnoremap <silent> <Space><Space> :<C-u>nohlsearch<CR><ESC>

"Sticky Shift----------
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

"�}�b�v��` - Normal���[�h----------
" �E�B���h�E�����̕���
set splitbelow
set splitright
" �f�t�H���g�̍ŏ��E�B���h�E�̍���
set winminheight=0
" <C-w><Space>�܂���<Tab>�Ŏ��̃E�B���h�E�Ɉړ�����
nnoremap <C-w><Space> <C-w>w
nnoremap <Tab> <C-w>w

" H�őO�̃o�b�t�@��\��
nnoremap H :<C-u>bprevious<CR>
" L�Ŏ��̃o�b�t�@��\��
nnoremap L :<C-u>bnext<CR>

"�}�b�v��` - Visual���[�h----------

"�}�b�v��` - Insert���[�h----------
" ]����͂����ۂɁA�Ή����銇�ʂ�������Ȃ��ꍇ�͕⊮�L�[�Ƃ���
inoremap <silent> <expr> ] searchpair('\[', '', '\]', 'nbW', 'synIDattr(synID(line("."), col("."), 1), "name") =~? "String"') ? ']' : "\<C-n>"

"�}�b�v��` - Command-line���[�h----------

"Plug-in�p�ݒ�----------
" vim-quickrun�p�ݒ�
let g:quickrun_config = {'*' :{'hook/shebang/enable' : '0'}}
" Windows�p�ݒ�
if executable('Perl') && s:chk_win
    let g:quickrun_config.perl = {'hook/output_encode/encoding' : 'cp932'}
endif

" ctrlp�p�ݒ�
let g:ctrlp_cache_dir       = $MISCVIM . '/tmp/ctrlp/'
let g:ctrlp_use_caching     = 1
let g:ctrlp_max_files       = 1024
let g:ctrlp_max_depth       = 5


set secure
