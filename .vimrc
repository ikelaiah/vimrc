" ==========================================================
"  IKELAIAH - PROFESSIONAL MINIMAL WORK VIM CONFIG
"  Languages: Markdown, JS, Python, PHP, SQL
"  Philosophy: Minimal. Stable. No plugins.
"
"  SECTION ORDER (logical flow):
"    1. Foundation       - The bedrock; must come first
"    2. Editing          - How text is typed, deleted, indented
"    3. User Interface   - What you see on screen
"    4. Search           - Finding things
"    5. Clipboard & Undo - Saving your sanity
"    6. File Navigation  - Moving between files and splits
"    7. Session Support  - Project memory
"    8. File Types       - Per-language settings
"    9. Enhancements     - Quality-of-life extras
" ==========================================================


" ----------------------------------------------------------
" 1. FOUNDATION
"    These must be set first — they govern how Vim behaves
"    at its most fundamental level.
" ----------------------------------------------------------

" Disable Vi compatibility mode. This unlocks all of Vim's
" modern features. Always set this first.
set nocompatible

" Enable syntax highlighting — colours keywords, strings, etc.
syntax on

" Enable filetype detection, language-specific plugins,
" and smart indentation per file type.
filetype plugin indent on

" Use UTF-8 for all text encoding — essential for modern work.
set encoding=utf-8

" Make backspace behave as you'd expect in any normal editor:
"   indent = delete auto-indented spaces
"   eol    = delete across line endings (join lines)
"   start  = delete characters before where Insert mode began
set backspace=indent,eol,start

" Prompt to save unsaved changes when quitting, instead of
" failing with an error. Prevents accidental data loss.
set confirm

" Disable swap files — persistent undo (Section 5) already
" protects against data loss, and .swp files clutter the workspace.
set noswapfile


" ----------------------------------------------------------
" 2. EDITING
"    How text is inserted, indented, and structured.
" ----------------------------------------------------------

" Use spaces instead of tab characters when you press <Tab>.
set expandtab

" Number of spaces used for each level of indentation.
set shiftwidth=4

" Number of spaces a <Tab> character visually represents.
set tabstop=4

" Number of spaces inserted/removed when pressing <Tab> or <BS>
" in Insert mode. Lets backspace delete a full indent level.
set softtabstop=4

" Keep 1000 lines of command history (e.g., : commands).
set history=1000

" Live preview of :substitute — you see the change as you type.
" Only available in Neovim and some modern Vim builds.
if exists('&inccommand')
  set inccommand=split
endif


" ----------------------------------------------------------
" 3. USER INTERFACE
"    Everything that affects what you see on screen.
" ----------------------------------------------------------

" Show absolute line numbers in the left gutter.
set number

" Do NOT show relative line numbers (lines above/below cursor).
" Turn this on if you use motion commands like 5j or 12k often.
set norelativenumber

" Highlight the entire line the cursor is currently on.
set cursorline

" Show the command you're typing in the bottom-right corner.
set showcmd

" Show cursor position (line, column) in the status bar.
set ruler

" Always show the sign column (left of numbers).
" Prevents the screen from jumping when signs appear/disappear.
set signcolumn=yes

" Keep 8 lines visible above and below the cursor at all times.
" Prevents editing at the very edge of the screen.
set scrolloff=8

" Do not wrap long lines — they scroll off screen instead.
" Markdown overrides this (see File Types section).
set nowrap

" Split windows appear below (not above) for horizontal splits.
set splitbelow

" Split windows appear to the right for vertical splits.
set splitright

" Hide invisible characters (tabs, trailing spaces, etc.) by default.
" Toggle this on/off with <leader>w (mapped below).
set nolist
set listchars=tab:»·,trail:·,extends:>,precedes:<,nbsp:+

" Improve rendering speed by not redrawing during macros.
" Note: may occasionally cause visual artifacts in some terminals.
" If you see redraw glitches, try commenting this out.
set lazyredraw

" Hint to Vim that you have a fast terminal connection.
set ttyfast

" Custom statusline:
"   %f  = file path
"   %h  = [help] flag
"   %m  = [modified] flag
"   %r  = [readonly] flag
"   %=  = push remaining items to the right
"   %l  = current line, %c = column, %V = virtual column
"   %P  = percentage through the file
set statusline=%f\ %h%m%r\ %=%-14.(%l,%c%V%)\ %P

" Enable 24-bit (true) colour if the terminal supports it.
if has("termguicolors")
  set termguicolors
endif

set background=dark

" Prefer gruvbox when available; fall back to desert otherwise.
try
  colorscheme gruvbox
catch
  colorscheme desert
endtry


" ----------------------------------------------------------
" 4. SEARCH
"    How Vim finds text in your files.
" ----------------------------------------------------------

" Case-insensitive searching by default.
set ignorecase

" BUT if you type any uppercase letter, the search becomes
" case-sensitive. (Works together with ignorecase.)
set smartcase

" Jump to the first match as you type each character.
set incsearch

" Highlight ALL matches of the search term in the file.
set hlsearch

" Press <Esc><Esc> in Normal mode to clear the search highlight.
" The :noh command turns off highlighting without clearing the search.
nnoremap <esc><esc> :noh<CR>


" ----------------------------------------------------------
" 5. CLIPBOARD & UNDO
"    Persist your history and share with the OS clipboard.
" ----------------------------------------------------------

" Use the system clipboard for all yank/paste operations,
" so Ctrl+C / Ctrl+V work as expected outside Vim too.
if has("clipboard")
  set clipboard=unnamedplus
endif

" Save undo history to disk so it survives closing and reopening files.
" You must create this folder first: mkdir -p ~/.vim/undodir
set undofile
set undodir=~/.vim/undodir

" Maximum number of undo steps to remember.
set undolevels=10000

" Lines saved for undo when a file is reloaded (e.g., after :e!).
set undoreload=10000


" ----------------------------------------------------------
" 6. FILE NAVIGATION
"    Finding and moving between files, directories, splits.
" ----------------------------------------------------------

" Search into subdirectories recursively with :find.
" e.g., :find myfile.py will search all nested folders.
set path+=**

" Show a completion menu when Tab-completing commands/filenames.
set wildmenu

" First Tab press completes to longest common match;
" next Tab press cycles through the full list.
set wildmode=longest:full,full

" Ignore these directories and files in :find, wildmenu, and glob.
" Keeps results clean — you almost never want to open these directly.
set wildignore+=**/node_modules/**,**/.git/**,**/__pycache__/**
set wildignore+=*.pyc,*.o,*.obj,*.class
set wildignore+=*.swp,*.bak,*.tmp

" Set the <leader> key to backslash (\).
" Leader is a prefix for your custom shortcuts below.
let mapleader="\\"

" Navigate between split windows using Ctrl + direction keys,
" instead of the default Ctrl+W then h/j/k/l.
"   <C-h> = move to the split on the LEFT
"   <C-j> = move to the split BELOW
"   <C-k> = move to the split ABOVE
"   <C-l> = move to the split on the RIGHT
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Toggle display of invisible characters (tabs, spaces, etc.)
nnoremap <leader>w :set list!<CR>

" Run :make (linter/compiler) from Normal mode.
" Results appear in the Quickfix window (see below).
nnoremap <leader>l :make<CR>

" Quick Git diff of the current file in the terminal.
nnoremap <leader>gd :!git diff %<CR>

" --- Buffer Navigation ---
" List all open buffers and prompt for a buffer number.
nnoremap <leader>b :ls<CR>:b<Space>
" Jump to the next buffer.
nnoremap <leader>n :bnext<CR>
" Jump to the previous buffer.
nnoremap <leader>p :bprev<CR>

" --- Quick Save ---
" Ctrl+s saves the file from Normal or Insert mode.
" Note: some terminals intercept Ctrl+s (XOFF). If so, add
" 'stty -ixon' to your shell profile to disable flow control.
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" --- Move Lines ---
" Alt+j moves the current line down, Alt+k moves it up.
" Works in both Normal and Visual mode.
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" --- Persistent Visual Indentation ---
" After indenting in Visual mode, reselect the same block
" so you can keep adjusting without re-selecting.
vnoremap < <gv
vnoremap > >gv

" --- Quickfix Navigation ---
" Jump to the next/previous lint error or search result.
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>

" Automatically open the Quickfix window after :make or :grep.
" '[^l]*' targets :make and :grep but not :lmake / :lgrep.
augroup quickfix_autoopen
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
augroup END

" Auto-close the Quickfix window when it is the last window open.
" Prevents an orphaned Quickfix from blocking Vim exit.
augroup quickfix_autoclose
  autocmd!
  autocmd WinEnter * if winnr('$') == 1 && &buftype == 'quickfix' | quit | endif
augroup END


" ----------------------------------------------------------
" 7. SESSION SUPPORT (PROJECT MEMORY)
"    Automatically saves and restores your open window layout.
" ----------------------------------------------------------

" Exclude these from saved sessions to keep them portable:
"   options     = global option values (can break other projects)
"   localoptions = buffer-local options
"   globals     = global variables
set sessionoptions-=options
set sessionoptions-=localoptions
set sessionoptions-=globals

augroup project_session
  autocmd!
  " When Vim starts with no file arguments and a .vimsession file
  " exists in the current directory, load it to restore your layout.
  autocmd VimEnter * if argc() == 0 && filereadable(".vimsession") | source .vimsession | endif

  " When Vim exits with no files open (argc() == 0 means no
  " arguments were given), save the session for next time.
  autocmd VimLeavePre * if argc() == 0 | mksession! .vimsession | endif
augroup END

" When you re-open a file, jump to where the cursor was last time.
augroup restore_cursor
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif
augroup END


" ----------------------------------------------------------
" 8. FILE TYPE SETTINGS
"    Language-specific overrides for indentation, linting, running.
"
"    Key shortcuts available inside each file type:
"      <leader>r = Run the current file
"      <leader>f = Format/prettify the current file
"      <leader>l = Lint the current file (via :make)
" ----------------------------------------------------------

" --- Python ---
augroup python_settings
  autocmd!
  " PEP 8 standard: 4-space indentation.
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
  " Use flake8 as the linter when you run :make or <leader>l.
  autocmd FileType python setlocal makeprg=flake8\ %
  " Tell Vim how to parse flake8 error output into the Quickfix list.
  autocmd FileType python setlocal errorformat=%f:%l:%c:\ %m
  " <leader>r runs the current Python file in the terminal.
  autocmd FileType python nnoremap <buffer> <leader>r :!python3 %<CR>
augroup END

" --- JavaScript ---
augroup javascript_settings
  autocmd!
  " JavaScript convention: 2-space indentation.
  autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  " Use ESLint as the linter.
  autocmd FileType javascript setlocal makeprg=npx\ eslint\ --format\ compact\ %
  " Parse ESLint's compact output format into the Quickfix list.
  autocmd FileType javascript setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
  " <leader>r runs the file with Node.js.
  autocmd FileType javascript nnoremap <buffer> <leader>r :!node %<CR>
  " <leader>f formats the file with Prettier (auto-formats style).
  autocmd FileType javascript nnoremap <buffer> <leader>f :!npx prettier --write %<CR>
augroup END

" --- PHP ---
augroup php_settings
  autocmd!
  " PHP standard: 4-space indentation.
  autocmd FileType php setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
  " Use php -l (lint only, no execution) for syntax checking.
  autocmd FileType php setlocal makeprg=php\ -l\ %
  " Parse PHP's error format.
  autocmd FileType php setlocal errorformat=%m\ in\ %f\ on\ line\ %l
  " <leader>r executes the file with PHP.
  autocmd FileType php nnoremap <buffer> <leader>r :!php %<CR>
augroup END

" --- SQL ---
augroup sql_settings
  autocmd!
  " SQL standard: 4-space indentation.
  autocmd FileType sql setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
  " Use psql to run SQL files via :make. Adjust for DB2/MySQL as needed.
  autocmd FileType sql setlocal makeprg=psql\ -f\ %
augroup END

" --- Markdown ---
augroup markdown_settings
  autocmd!
  " Wrap long lines visually — important for readable prose.
  autocmd FileType markdown setlocal wrap
  " Break wrapped lines at word boundaries, not mid-word.
  autocmd FileType markdown setlocal linebreak
  " Enable spell checking (use z= to see suggestions for a word).
  autocmd FileType markdown setlocal spell
  " Enforce a max line width of 80 characters (good writing practice).
  autocmd FileType markdown setlocal textwidth=80
  " <leader>f formats the Markdown file with Prettier.
  autocmd FileType markdown nnoremap <buffer> <leader>f :!prettier --write %<CR>
augroup END


" --- HTML ---
augroup html_settings
  autocmd!
  " HTML standard: 2-space indentation.
  autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END


" --- CSS ---
augroup css_settings
  autocmd!
  " CSS convention: 2-space indentation.
  autocmd FileType css setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END


" --- JSON ---
augroup json_settings
  autocmd!
  " JSON standard: 2-space indentation.
  autocmd FileType json setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  " Optional formatting via Prettier.
  autocmd FileType json nnoremap <buffer> <leader>f :!npx prettier --write %<CR>
augroup END


" --- YAML ---
augroup yaml_settings
  autocmd!
  " YAML requires strict 2-space indentation (tabs break YAML).
  autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END


" ----------------------------------------------------------
" 9. ENHANCEMENTS
"    Quality-of-life additions that keep things clean and smooth.
" ----------------------------------------------------------

" Highlight trailing whitespace in red — a visual warning.
highlight ExtraWhitespace ctermbg=red guibg=red
augroup highlight_whitespace
  autocmd!
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
augroup END

" Automatically strip trailing whitespace when saving any file.
" This keeps your diffs clean and your colleagues happy.
" Markdown is excluded — trailing double-spaces create <br> line breaks.
augroup trim_whitespace
  autocmd!
  autocmd BufWritePre * if &filetype != 'markdown' | %s/\s\+$//e | endif
augroup END

" If Vim detects a file has changed on disk (e.g., via git pull),
" automatically reload it without prompting.
set autoread
augroup auto_reload
  autocmd!
  autocmd FocusGained,BufEnter * checktime
augroup END

" Improved diff algorithm settings (used by vimdiff and git):
"   vertical          = always split vertically (side by side)
"   indent-heuristic  = smarter about indented blocks
"   algorithm:histogram = more accurate, human-readable diffs
set diffopt+=vertical
set diffopt+=indent-heuristic
set diffopt+=algorithm:histogram


" ==========================================================
" END OF CONFIG
" vim: set ft=vim :
" ==========================================================