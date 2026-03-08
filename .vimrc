" ==========================================================
" Corporate Safe Vim Configuration
" Pure Vim — No plugins, no external tools
" ==========================================================

set nocompatible
filetype plugin indent on
syntax on

" ----------------------------------------------------------
" Leader key (must be set before any mappings)
" ----------------------------------------------------------
let mapleader=" "

" ==========================================================
" Ensure vim directories exist
" ==========================================================

if has('win32')
    if !isdirectory($HOME."/vimfiles/backup")
        call mkdir($HOME."/vimfiles/backup", "p")
    endif
    if !isdirectory($HOME."/vimfiles/undo")
        call mkdir($HOME."/vimfiles/undo", "p")
    endif
    if !isdirectory($HOME."/vimfiles/sessions")
        call mkdir($HOME."/vimfiles/sessions", "p")
    endif
else
    if !isdirectory($HOME."/.vim")
        call mkdir($HOME."/.vim", "p")
    endif
    if !isdirectory($HOME."/.vim/backup")
        call mkdir($HOME."/.vim/backup", "p")
    endif
    if !isdirectory($HOME."/.vim/undo")
        call mkdir($HOME."/.vim/undo", "p")
    endif
    if !isdirectory($HOME."/.vim/sessions")
        call mkdir($HOME."/.vim/sessions", "p")
    endif
endif

" ----------------------------------------------------------
" Truecolor if supported
" ----------------------------------------------------------
if has("termguicolors")
    set termguicolors
endif

" ----------------------------------------------------------
" Theme fallback
" ----------------------------------------------------------
set background=dark
silent! colorscheme gruvbox
if !exists('g:colors_name') || g:colors_name !=# "gruvbox"
    colorscheme desert
endif

" ----------------------------------------------------------
" Reduce message noise
" ----------------------------------------------------------
set shortmess+=F
set shortmess+=I

" ----------------------------------------------------------
" Interface
" ----------------------------------------------------------
set number
set relativenumber
set cursorline
set signcolumn=auto

set ruler
set showcmd
set showmode
set laststatus=2

set scrolloff=6
set sidescrolloff=6

set splitbelow
set splitright

set wildmenu
set wildmode=longest:full
set wildignorecase
set infercase
set completeopt=menuone,noinsert,noselect
set switchbuf=useopen

set colorcolumn=100

" ----------------------------------------------------------
" Searching
" ----------------------------------------------------------
set ignorecase
set smartcase
set incsearch
set hlsearch
set nowrapscan

nnoremap <leader>/ :nohlsearch<CR>

" ----------------------------------------------------------
" Performance
" ----------------------------------------------------------
set lazyredraw
set updatetime=300
set synmaxcol=240
set hidden
set timeoutlen=500

" ----------------------------------------------------------
" Indentation
" ----------------------------------------------------------
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set autoindent

augroup FileTypeSettings
    autocmd!
    autocmd FileType javascript,css,json,yaml,toml,lua setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType markdown setlocal wrap linebreak
    autocmd FileType make setlocal noexpandtab
augroup END

" ----------------------------------------------------------
" Built-in project file search
" ----------------------------------------------------------
set path+=**

set wildignore+=*/node_modules/*
set wildignore+=*/dist/*
set wildignore+=*/build/*
set wildignore+=*/vendor/*
set wildignore+=*/.git/*

" ----------------------------------------------------------
" Clipboard
" ----------------------------------------------------------
if has("clipboard")
    set clipboard=unnamed,unnamedplus
endif

" ----------------------------------------------------------
" Backup safety
" ----------------------------------------------------------
set backup
set writebackup
set noswapfile
set undofile

set autoread
augroup AutoRead
    autocmd!
    autocmd FocusGained,BufEnter * checktime
augroup END

if has('win32')
    set backupdir=~/vimfiles/backup//
    set undodir=~/vimfiles/undo//
else
    set backupdir=~/.vim/backup//
    set undodir=~/.vim/undo//
endif

" ----------------------------------------------------------
" Save / quit
" ----------------------------------------------------------
nnoremap <leader>w :write<CR>
nnoremap <leader>q :confirm quit<CR>
nnoremap <leader>x :xit<CR>
nnoremap <leader>Q :quit!<CR>

" ----------------------------------------------------------
" Buffers
" ----------------------------------------------------------
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>

nnoremap <leader><leader> <C-^>

" ----------------------------------------------------------
" Window navigation
" ----------------------------------------------------------
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ----------------------------------------------------------
" Window splitting
" ----------------------------------------------------------
nnoremap <leader>- :split<CR>
nnoremap <leader>\ :vsplit<CR>

" ----------------------------------------------------------
" Resize splits
" ----------------------------------------------------------
nnoremap <leader><Left>  :vertical resize -10<CR>
nnoremap <leader><Right> :vertical resize +10<CR>
nnoremap <leader><Up>    :resize +5<CR>
nnoremap <leader><Down>  :resize -5<CR>
nnoremap <leader>= <C-w>=
nnoremap <leader>c :close<CR>
nnoremap <leader>o :only<CR>

" ----------------------------------------------------------
" Netrw (VSCode-style sidebar)
" ----------------------------------------------------------
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=0
let g:netrw_altv=1
let g:netrw_winsize=25
let g:netrw_sort_by = 'name'
let g:netrw_keepdir = 0

" Sidebar explorer toggle
nnoremap <leader>e :Lexplore<CR>

" Fix C-l conflict with netrw's refresh binding
augroup NetrwFix
    autocmd!
    autocmd FileType netrw noremap <buffer> <C-l> <C-w>l
augroup END

" ----------------------------------------------------------
" File search
" ----------------------------------------------------------
nnoremap <leader>f :find<Space>

" ----------------------------------------------------------
" Project search (pure Vim)
" ----------------------------------------------------------
nnoremap <leader>g :vimgrep /

nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>

nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :cclose<CR>

" ----------------------------------------------------------
" Movement improvements
" ----------------------------------------------------------
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

nnoremap Y y$

vnoremap < <gv
vnoremap > >gv

" ----------------------------------------------------------
" Whitespace visibility
" ----------------------------------------------------------
set list
set listchars=tab:»·,trail:·,nbsp:␣
nnoremap <leader>l :set list!<CR>

" ----------------------------------------------------------
" Paste mode
" ----------------------------------------------------------
set pastetoggle=<F2>
nnoremap <leader>z :set wrap!<CR>

" ----------------------------------------------------------
" Statusline
" ----------------------------------------------------------
set statusline=%f\ %m%r\ [%Y]\ %=%l:%c\ (%p%%)

" ----------------------------------------------------------
" Sessions
" ----------------------------------------------------------
" Skip terminals (avoids broken terminal buffer on restore),
" skip blank/missing buffers, keep window layout + tabs + folds.
set sessionoptions=curdir,folds,tabpages,winsize,winpos

if has('win32')
    let s:session_dir = $HOME . '/vimfiles/sessions'
else
    let s:session_dir = $HOME . '/.vim/sessions'
endif

let s:session_file = s:session_dir . '/default.vim'

" Auto-restore session when Vim starts with no file args, or with only a directory arg
" Auto-save session on exit in those same cases
function! s:ShouldUseSession() abort
    if argc() == 0
        return 1
    endif
    " Single argument that is a directory (e.g. vim .)
    if argc() == 1 && isdirectory(argv(0))
        return 1
    endif
    return 0
endfunction

augroup Session
    autocmd!
    autocmd VimEnter * nested
        \ if s:ShouldUseSession() && filereadable(s:session_file) |
        \     silent! execute 'source ' . fnameescape(s:session_file) |
        \     call s:CleanMissingBuffers() |
        \ endif |
        \ if argc() == 1 && isdirectory(argv(0)) |
        \     execute 'cd ' . fnameescape(fnamemodify(argv(0), ':p')) |
        \ endif
    autocmd VimLeave *
        \ if s:ShouldUseSession() |
        \     silent! execute 'mksession! ' . fnameescape(s:session_file) |
        \ endif
augroup END

function! s:CleanMissingBuffers() abort
    for l:buf in range(1, bufnr('$'))
        if !bufexists(l:buf)
            continue
        endif
        let l:name = bufname(l:buf)
        let l:ft   = getbufvar(l:buf, '&filetype')
        let l:bt   = getbufvar(l:buf, '&buftype')

        " Wipe terminal buffers (term://)
        if l:name =~# '^term://'
            silent! execute 'bwipeout! ' . l:buf | continue
        endif
        " Wipe netrw (restores broken w:netrw_treetop state)
        if l:ft ==# 'netrw'
            silent! execute 'bwipeout! ' . l:buf | continue
        endif
        " Wipe quickfix / location list windows
        if l:bt ==# 'quickfix'
            silent! execute 'bwipeout! ' . l:buf | continue
        endif
        " Wipe nofile/nowrite scratch buffers (help, man, etc.)
        if l:bt ==# 'nofile' || l:bt ==# 'nowrite'
            silent! execute 'bwipeout! ' . l:buf | continue
        endif
        " Wipe unnamed buffers
        if empty(l:name)
            continue
        endif
        " Wipe listed buffers whose file no longer exists on disk
        if buflisted(l:buf) && !filereadable(expand(l:name))
            silent! execute 'bwipeout! ' . l:buf
        endif
    endfor
endfunction

nnoremap <leader>ss :execute 'mksession! ' . fnameescape(s:session_file) \| echo 'Session saved'<CR>
nnoremap <leader>sr :call s:CleanMissingBuffers() \| execute 'source ' . fnameescape(s:session_file) \| echo 'Session restored'<CR>
nnoremap <leader>sd :call delete(s:session_file) \| echo 'Session deleted'<CR>

" ----------------------------------------------------------
" Vimrc shortcuts
" ----------------------------------------------------------
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
