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

" ----------------------------------------------------------
" Indentation
" ----------------------------------------------------------
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set autoindent

autocmd FileType javascript,css,json,yaml,toml,lua setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType markdown setlocal wrap linebreak
autocmd FileType make setlocal noexpandtab

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
autocmd FocusGained,BufEnter * checktime

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
nnoremap <leader>q :quit<CR>
nnoremap <leader>x :xit<CR>

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
" Resize splits
" ----------------------------------------------------------
nnoremap <leader><Left>  :vertical resize -5<CR>
nnoremap <leader><Right> :vertical resize +5<CR>
nnoremap <leader><Up>    :resize +3<CR>
nnoremap <leader><Down>  :resize -3<CR>

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
autocmd FileType netrw noremap <buffer> <C-l> <C-w>l

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

" ----------------------------------------------------------
" Paste mode
" ----------------------------------------------------------
set pastetoggle=<F2>

" ----------------------------------------------------------
" Statusline
" ----------------------------------------------------------
set statusline=%f\ %m%r\ [%Y]\ %=%l:%c\ (%p%%)

" ----------------------------------------------------------
" Vimrc shortcuts
" ----------------------------------------------------------
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
