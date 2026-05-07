" ==========================================================
" Corporate-Safe Vim Configuration
" Plugin-free stock Vim: no additional plugins or external tools
" ==========================================================

set nocompatible
if has('multi_byte')
    set encoding=utf-8
    set fileencodings=utf-8,default,latin1
endif
let g:corporate_safe_vim_version = '1.4.0'
let g:corporate_safe_auto_sessions = get(g:, 'corporate_safe_auto_sessions', 1)
let g:corporate_safe_deep_find = get(g:, 'corporate_safe_deep_find', 1)
let g:corporate_safe_search_glob = get(g:, 'corporate_safe_search_glob', '**/*')
let g:corporate_safe_legacy_glob = get(g:, 'corporate_safe_legacy_glob', get(g:, 'corporate_safe_search_glob', '**/*'))
let g:corporate_safe_no_local_state = get(g:, 'corporate_safe_no_local_state', 0)
let g:corporate_safe_auto_clipboard = get(g:, 'corporate_safe_auto_clipboard', 0)
let g:corporate_safe_large_file_bytes = get(g:, 'corporate_safe_large_file_bytes', 2097152)
filetype plugin indent on
syntax on

" ----------------------------------------------------------
" Leader key (must be set before any mappings)
" ----------------------------------------------------------
let mapleader=" "

" ----------------------------------------------------------
" File trust safety
" ----------------------------------------------------------
set noexrc
set nomodeline
set modelines=0

" ==========================================================
" Ensure vim directories exist
" ==========================================================

function! s:EnsureDir(path) abort
    let l:path = expand(a:path)
    if isdirectory(l:path)
        return l:path
    endif
    try
        call mkdir(l:path, 'p')
    catch
        echohl WarningMsg
        echom 'Could not create Vim directory: ' . l:path
        echom 'Using Vim defaults for the affected feature.'
        echohl None
        return ''
    endtry
    if isdirectory(l:path)
        return l:path
    endif
    echohl WarningMsg
    echom 'Could not create Vim directory: ' . l:path
    echom 'Using Vim defaults for the affected feature.'
    echohl None
    return ''
endfunction

if has('win32') || has('win64')
    let s:state_root = $HOME . '/vimfiles'
else
    let s:state_root = $HOME . '/.vim'
endif

if get(g:, 'corporate_safe_no_local_state', 0)
    let s:backup_dir = ''
    let s:undo_dir = ''
    let s:swap_dir = ''
    let s:session_dir = ''
else
    let s:backup_dir = s:EnsureDir(s:state_root . '/backup')
    let s:undo_dir = s:EnsureDir(s:state_root . '/undo')
    let s:swap_dir = s:EnsureDir(s:state_root . '/swap')
    let s:session_dir = s:EnsureDir(s:state_root . '/sessions')
endif

" ----------------------------------------------------------
" Truecolor if supported
" ----------------------------------------------------------
if exists('&termguicolors')
    silent! set termguicolors
endif

" ----------------------------------------------------------
" Theme fallback
" ----------------------------------------------------------
set background=dark
silent! colorscheme gruvbox
if !exists('g:colors_name') || g:colors_name !=# "gruvbox"
    silent! colorscheme desert
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
set norelativenumber
set cursorline
if exists('&signcolumn')
    set signcolumn=yes
endif

set backspace=indent,eol,start
set confirm
set nostartofline
if exists('&breakindent')
    set breakindent
endif
if exists('&virtualedit')
    set virtualedit=block
endif

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
if exists('&inccommand')
    set inccommand=nosplit
endif

nnoremap <leader>/ :nohlsearch<CR>

" ----------------------------------------------------------
" Performance
" ----------------------------------------------------------
set updatetime=300
set synmaxcol=240
set hidden
set timeoutlen=900

" ----------------------------------------------------------
" Indentation
" ----------------------------------------------------------
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set autoindent
set nrformats-=octal
set formatoptions-=o

augroup FileTypeSettings
    autocmd!
    autocmd FileType * setlocal formatoptions-=o
    autocmd FileType javascript,javascriptreact,typescript,typescriptreact,css,scss,sass,less,html,xml,json,yaml,toml,lua,vue,svelte setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType markdown setlocal wrap linebreak colorcolumn=0
    autocmd FileType help setlocal colorcolumn=0 nolist
    autocmd FileType make setlocal noexpandtab
    autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=0
augroup END

" ----------------------------------------------------------
" Built-in project file search
" ----------------------------------------------------------
if get(g:, 'corporate_safe_deep_find', 1)
    set path+=**
endif
set tags=./tags;,tags;

set wildignore+=*/node_modules/*
set wildignore+=*/dist/*
set wildignore+=*/build/*
set wildignore+=*/vendor/*
set wildignore+=*/.git/*
set wildignore+=*/.venv/*
set wildignore+=*/venv/*
set wildignore+=*/coverage/*
set wildignore+=*/.pytest_cache/*
set wildignore+=*/.mypy_cache/*
set wildignore+=*/.next/*
set wildignore+=*/target/*

" ----------------------------------------------------------
" Clipboard
" ----------------------------------------------------------
if has("clipboard")
    if get(g:, 'corporate_safe_auto_clipboard', 0)
        set clipboard=unnamed,unnamedplus
    endif
    nnoremap <leader>y "+y
    vnoremap <leader>y "+y
    nnoremap <leader>p "+p
    vnoremap <leader>p "+p
endif

" ----------------------------------------------------------
" Backup safety
" ----------------------------------------------------------
set diffopt+=vertical

if get(g:, 'corporate_safe_no_local_state', 0)
    set nobackup
    set nowritebackup
    set noswapfile
    set noundofile
    if exists('&viminfo')
        set viminfo=
    endif
    if exists('&shada')
        set shada=
    endif
else
    set backup
    set writebackup
    set swapfile
    set undofile
endif

set autoread
augroup AutoRead
    autocmd!
    autocmd FocusGained,BufEnter * checktime
augroup END

function! s:MaybeApplyLargeFileMode() abort
    let l:already_applied = get(b:, 'corporate_safe_large_file_applied', 0)
    let l:limit = get(g:, 'corporate_safe_large_file_bytes', 2097152)
    if l:limit <= 0
        return
    endif
    let l:file = expand('<afile>:p')
    if empty(l:file)
        let l:file = expand('%:p')
    endif
    let l:size = getfsize(l:file)
    if l:size <= l:limit
        return
    endif

    let b:corporate_safe_large_file = 1
    let b:corporate_safe_large_file_applied = 1
    setlocal nolist nowrap
    if exists('&syntax')
        setlocal syntax=OFF
    endif
    if exists('&foldmethod')
        setlocal foldmethod=manual
    endif
    if !l:already_applied
        echom 'Large file mode: disabled syntax, folds, wrap, and listchars for ' . fnamemodify(l:file, ':~')
    endif
endfunction

augroup LargeFileMode
    autocmd!
    autocmd BufReadPost * call s:MaybeApplyLargeFileMode()
    autocmd FileType * call s:MaybeApplyLargeFileMode()
augroup END

augroup NoLocalState
    autocmd!
    if get(g:, 'corporate_safe_no_local_state', 0)
        autocmd BufNewFile,BufRead,BufEnter * setlocal noswapfile
    endif
augroup END

if !get(g:, 'corporate_safe_no_local_state', 0)
    if !empty(s:backup_dir)
        let &backupdir = s:backup_dir . '//'
    endif
    if !empty(s:swap_dir)
        let &directory = s:swap_dir . '//'
    endif
    if !empty(s:undo_dir)
        let &undodir = s:undo_dir . '//'
    endif
endif

" ----------------------------------------------------------
" Built-in help
" ----------------------------------------------------------
function! s:ShowHelp() abort
    botright new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
    file Corporate-Safe-Vim-Help
    call setline(1, [
        \ 'Corporate-Safe Vim Cheatsheet (Plugin-Free)',
        \ 'Version ' . get(g:, 'corporate_safe_vim_version', 'unknown'),
        \ '',
        \ 'Start Here',
        \ '  <Space>?     show this cheatsheet',
        \ '  <Space>e     toggle project sidebar',
        \ '  <Space>ff    find file in project path',
        \ '  <Space>g     search project and open quickfix',
        \ '  <Space>w     save current file',
        \ '  ]q / [q      next / previous quickfix result',
        \ '  <Space>qq    toggle quickfix results',
        \ '',
        \ 'Project Feel',
        \ '  Auto sessions are on by default for folder opens like: vim .',
        \ '  Session files live under the centralized Vim runtime directory.',
        \ '  Use :CorporateSafeHealth to inspect paths, mappings, and opt-outs.',
        \ '',
        \ 'Files',
        \ '  <Space>ff    find file in project path',
        \ '  <Space>e     toggle project explorer',
        \ '  <Space>fr    open recent file',
        \ '  <Space><Space> switch to alternate file',
        \ '  <Space>cd    local cwd to current file directory',
        \ '',
        \ 'Search',
        \ '  <Space>g     search project',
        \ '  <Space>fw    search word under cursor',
        \ '  File glob examples: **/*, **/*.py, app/**/*.js',
        \ '  ]q / [q      next / previous quickfix result',
        \ '  <Space>co    open quickfix',
        \ '  <Space>cc    close quickfix',
        \ '  <Space>qq    toggle quickfix',
        \ '  <Space>cw    open quickfix only when it has entries',
        \ '  <Space>cn/cp newer / older quickfix list',
        \ '',
        \ 'Legacy Code',
        \ '  <Space>fo    current file function/class outline',
        \ '  <Space>fd    find likely definition for symbol',
        \ '  <Space>fc    find callers/references for symbol',
        \ '  <Space>fF    combined symbol flow: definitions then references',
        \ '  <Space>fO    outgoing calls from current function',
        \ '  <Space>fI    inspect symbol: definitions, references, callees',
        \ '  <Space>fT    TODO/FIXME/HACK/BUG quickfix',
        \ '  <Space>fh    legacy hotspot quickfix',
        \ '  <Space>ft    jump/select from Vim tags when a tags file exists',
        \ '  <Space>fH    tags health report',
        \ '',
        \ 'Git (optional, uses installed git only when invoked)',
        \ '  <Space>Gs    git status',
        \ '  <Space>Gq    changed files in quickfix',
        \ '  <Space>Gd    diff current file',
        \ '  <Space>GD    staged diff for current file',
        \ '  <Space>Gl    recent log',
        \ '  <Space>Gb    blame current file',
        \ '  <Space>Ga    stage current file',
        \ '  <Space>GA    stage all changes with confirmation',
        \ '  <Space>Gu    unstage current file',
        \ '  <Space>GU    unstage all changes with confirmation',
        \ '  <Space>Gc    commit staged changes with message prompt',
        \ '  <Space>Gp    push',
        \ '  <Space>GP    pull --ff-only',
        \ '  <Space>Gr    restore current file with confirmation',
        \ '  <Space>Gg    run a git command',
        \ '',
        \ 'Buffers and Windows',
        \ '  <Space>bb    list buffers, then jump with :b',
        \ '  <Space>bn/bp next / previous buffer',
        \ '  <Space>bd    close buffer',
        \ '  Ctrl-h/j/k/l move between splits',
        \ '  <Space>-     horizontal split',
        \ '  <Space>\     vertical split',
        \ '  <Space>=     equalise windows',
        \ '',
        \ 'Editing',
        \ '  <Space>w     save',
        \ '  <Space>x     save and quit',
        \ '  <Space>q     quit with prompt',
        \ '  <Space>/     clear search highlight',
        \ '  <Space>l     toggle whitespace markers',
        \ '  <Space>tw    trim trailing whitespace in current file',
        \ '  <Space>rn    toggle relative line numbers',
        \ '  <Space>z     toggle wrap',
        \ '  <Space>y/p   system clipboard when supported',
        \ '',
        \ 'Sessions',
        \ '  <Space>ss    save session',
        \ '  <Space>sr    restore session',
        \ '  <Space>sd    delete session',
        \ '',
        \ 'Diagnostics',
        \ '  :CorporateSafeHealth show configuration health',
        \ '',
        \ 'Useful Opt-Outs',
        \ '  let g:corporate_safe_deep_find = 0       large repositories',
        \ '  let g:corporate_safe_no_local_state = 1  sensitive folders',
        \ '  let g:corporate_safe_auto_sessions = 0   no session restore/save',
        \ '',
        \ 'Runtime files',
        \ '  Git Bash/Linux/macOS: ~/.vim/{backup,undo,swap,sessions}',
        \ '  Native Windows Vim: ~/vimfiles/{backup,undo,swap,sessions}',
        \ '',
        \ 'Press q to close this help.'
        \ ])
    nnoremap <buffer> q :close<CR>
    setlocal nomodifiable nomodified
endfunction

function! s:YesNo(value) abort
    return a:value ? 'yes' : 'no'
endfunction

function! s:PathStatus(path) abort
    if empty(a:path)
        return get(g:, 'corporate_safe_no_local_state', 0) ? 'disabled' : 'unavailable'
    endif
    return fnamemodify(a:path, ':~') . ' [' . (isdirectory(a:path) ? 'ok' : 'missing') . ']'
endfunction

function! s:LocalStateStatus() abort
    return get(g:, 'corporate_safe_no_local_state', 0) ? 'disabled' : 'enabled'
endfunction

function! s:VimInfoStatus() abort
    if exists('&viminfo')
        return empty(&viminfo) ? 'disabled' : 'enabled'
    endif
    if exists('&shada')
        return empty(&shada) ? 'disabled' : 'enabled'
    endif
    return 'unavailable'
endfunction

function! s:OptionStatus(option, value) abort
    return exists(a:option) ? s:YesNo(a:value) : 'unavailable'
endfunction

function! s:NetrwStatus() abort
    return exists(':Lexplore') == 2 ? 'available' : 'unavailable'
endfunction

function! s:ClipboardMappingStatus() abort
    return has('clipboard') ? 'enabled' : 'unavailable'
endfunction

function! s:MappingLines() abort
    let l:lines = [
        \ '  <Space>?        help',
        \ '  :CorporateSafeHealth health report',
        \ '',
        \ '  Files',
        \ '    <Space>ff       find file in project path',
        \ '    <Space>e        toggle netrw explorer',
        \ '    <Space>fr       open recent file',
        \ '    <Space><Space> switch to alternate file',
        \ '    <Space>cd       change local cwd to current file directory',
        \ '',
        \ '  Search',
        \ '    <Space>g        search project',
        \ '    <Space>fw       search word under cursor',
        \ '    ]q / [q         next / previous quickfix result',
        \ '    <Space>co       open quickfix',
        \ '    <Space>cc       close quickfix',
        \ '    <Space>qq       toggle quickfix',
        \ '    <Space>cw       open quickfix only when it has entries',
        \ '    <Space>cn/cp    newer / older quickfix list',
        \ '',
        \ '  Legacy Code',
        \ '    <Space>fo       current file function/class outline',
        \ '    <Space>fd       find likely definition for symbol',
        \ '    <Space>fc       find callers/references for symbol',
        \ '    <Space>fF       combined symbol flow',
        \ '    <Space>fO       outgoing calls from current function',
        \ '    <Space>fI       inspect symbol flow report',
        \ '    <Space>fT       TODO/FIXME/HACK/BUG quickfix',
        \ '    <Space>fh       legacy hotspot quickfix',
        \ '    <Space>ft       jump/select from Vim tags',
        \ '    <Space>fH       tags health report',
        \ '',
        \ '  Git',
        \ '    <Space>Gs       git status',
        \ '    <Space>Gq       changed files in quickfix',
        \ '    <Space>Gd       diff current file',
        \ '    <Space>GD       staged diff for current file',
        \ '    <Space>Gl       recent log',
        \ '    <Space>Gb       blame current file',
        \ '    <Space>Ga       stage current file',
        \ '    <Space>GA       stage all changes with confirmation',
        \ '    <Space>Gu       unstage current file',
        \ '    <Space>GU       unstage all changes with confirmation',
        \ '    <Space>Gc       commit staged changes with message prompt',
        \ '    <Space>Gp       push',
        \ '    <Space>GP       pull --ff-only',
        \ '    <Space>Gr       restore current file with confirmation',
        \ '    <Space>Gg       run a git command',
        \ '',
        \ '  Buffers and Windows',
        \ '    <Space>bb       list buffers, then jump with :b',
        \ '    <Space>bn/bp    next / previous buffer',
        \ '    <Space>bd       close buffer',
        \ '    Ctrl-h/j/k/l    move between splits',
        \ '    <Space>-        horizontal split',
        \ '    <Space>\        vertical split',
        \ '    <Space>=        equalise windows',
        \ '    <Space>c        close split',
        \ '    <Space>o        keep only current split',
        \ '    <Space>Arrows   resize splits',
        \ '',
        \ '  Editing',
        \ '    <Space>w        save',
        \ '    <Space>x        save and quit',
        \ '    <Space>q        quit with prompt',
        \ '    <Space>/        clear search highlight',
        \ '    <Space>l        toggle whitespace markers',
        \ '    <Space>tw       trim trailing whitespace in current file',
        \ '    <Space>rn       toggle relative line numbers',
        \ '    <Space>z        toggle wrap',
        \ '    j/k             move by display lines without a count',
        \ '    Y               yank to end of line',
        \ '    < / >           keep visual selection after indent',
        \ '',
        \ '  Sessions',
        \ '    <Space>ss       save session',
        \ '    <Space>sr       restore session',
        \ '    <Space>sd       delete session',
        \ '',
        \ '  Vimrc',
        \ '    <Space>ev       edit vimrc',
        \ '    <Space>sv       source vimrc',
        \ ]
    if has('clipboard')
        call extend(l:lines, [
            \ '',
            \ '  Clipboard',
            \ '    <Space>y        yank to system clipboard',
            \ '    <Space>p        paste from system clipboard',
            \ ])
    endif
    return l:lines
endfunction

function! s:ShowHealth() abort
    let l:session_file = s:CurrentSessionFile()
    let l:vim_version = printf('%d.%02d', v:version / 100, v:version % 100)
    let l:lines = [
        \ 'Corporate-Safe Vim Health',
        \ '',
        \ 'Config',
        \ '  Version: ' . get(g:, 'corporate_safe_vim_version', 'unknown'),
        \ '  Vim: ' . l:vim_version,
        \ '  Plugins required: no',
        \ '  External tools required: no',
        \ '',
        \ 'Features',
        \ '  Clipboard: ' . s:YesNo(has('clipboard')),
        \ '  Clipboard mappings: ' . s:ClipboardMappingStatus(),
        \ '  Automatic clipboard: ' . s:YesNo(has('clipboard') && get(g:, 'corporate_safe_auto_clipboard', 0)),
        \ '  Git executable (optional): ' . s:GitExecutableStatus(),
        \ '  Git repository: ' . s:GitRootStatus(),
        \ '  Truecolor option: ' . s:YesNo(exists('&termguicolors')),
        \ '  Truecolor enabled: ' . s:OptionStatus('&termguicolors', exists('&termguicolors') && &termguicolors),
        \ '  Netrw Lexplore: ' . s:NetrwStatus(),
        \ '  TextYankPost: ' . s:YesNo(exists('##TextYankPost')),
        \ '  Timers: ' . s:YesNo(exists('*timer_start')),
        \ '  SHA-256: ' . s:YesNo(exists('*sha256')),
        \ '  Modelines enabled: ' . s:YesNo(&modeline),
        \ '  Local vimrc enabled: ' . s:YesNo(&exrc),
        \ '  Deep :find path: ' . s:YesNo(get(g:, 'corporate_safe_deep_find', 1)),
        \ '  Default search glob: ' . get(g:, 'corporate_safe_search_glob', '**/*'),
        \ '  Default legacy glob: ' . get(g:, 'corporate_safe_legacy_glob', get(g:, 'corporate_safe_search_glob', '**/*')),
        \ '  Large file limit bytes: ' . get(g:, 'corporate_safe_large_file_bytes', 2097152),
        \ '  Tags search path: ' . &tags,
        \ '  Local state writes: ' . s:LocalStateStatus(),
        \ '  Vim info file: ' . s:VimInfoStatus(),
        \ '',
        \ 'Runtime Directories',
        \ '  Backup: ' . s:PathStatus(s:backup_dir),
        \ '  Undo: ' . s:PathStatus(s:undo_dir),
        \ '  Swap: ' . s:PathStatus(s:swap_dir),
        \ '  Sessions: ' . s:PathStatus(s:session_dir),
        \ '',
        \ 'Project and Sessions',
        \ '  Auto sessions requested: ' . s:YesNo(get(g:, 'corporate_safe_auto_sessions', 1)),
        \ '  Auto sessions effective: ' . s:YesNo(get(g:, 'corporate_safe_auto_sessions', 1) && !get(g:, 'corporate_safe_no_local_state', 0)),
        \ '  Auto session for current launch: ' . s:YesNo(s:ShouldAutoSession()),
        \ '  Project root: ' . fnamemodify(s:ProjectRoot(), ':~'),
        \ '  Startup root: ' . (empty(s:startup_root) ? 'not set yet' : fnamemodify(s:startup_root, ':~')),
        \ '  Auto session root: ' . (empty(s:auto_session_root) ? 'not active' : fnamemodify(s:auto_session_root, ':~')),
        \ '  Current session root: ' . fnamemodify(s:CurrentSessionRoot(), ':~'),
        \ '  Current session file: ' . (empty(l:session_file) ? 'unavailable' : fnamemodify(l:session_file, ':~')),
        \ '  Session file exists: ' . s:YesNo(!empty(l:session_file) && filereadable(l:session_file)),
        \ '  Last session save: ' . s:last_session_save_status,
        \ '  Last session restore: ' . s:last_session_restore_status,
        \ '',
        \ 'Mappings',
        \ ]
    call extend(l:lines, s:MappingLines())
    call extend(l:lines, [
        \ '',
        \ 'Press q to close this health report.'
        \ ])
    botright new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
    file Corporate-Safe-Vim-Health
    call setline(1, l:lines)
    nnoremap <buffer> q :close<CR>
    setlocal nomodifiable nomodified
endfunction

nnoremap <leader>? :call <SID>ShowHelp()<CR>
command! CorporateSafeHealth call <SID>ShowHealth()

" ----------------------------------------------------------
" Save / quit
" ----------------------------------------------------------
nnoremap <leader>w :write<CR>
nnoremap <leader>q :confirm quit<CR>
nnoremap <leader>x :xit<CR>

" ----------------------------------------------------------
" Buffers
" ----------------------------------------------------------
nnoremap <leader>bb :ls<CR>:b<Space>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bd :bdelete<CR>

nnoremap <leader><leader> <C-^>
nnoremap <leader>rn :set relativenumber!<CR>

function! s:ChangeToFileDir() abort
    let l:dir = expand('%:p:h')
    if empty(l:dir) || !isdirectory(l:dir)
        echo 'No file directory for current buffer'
        return
    endif
    execute 'lcd ' . fnameescape(l:dir)
    pwd
endfunction

nnoremap <leader>cd :call <SID>ChangeToFileDir()<CR>

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
let g:netrw_keepdir = 1

" Sidebar explorer toggle
nnoremap <silent> <leader>e :call <SID>OpenProjectExplorer()<CR>

" Fix C-l conflict with netrw's refresh binding
augroup NetrwFix
    autocmd!
    autocmd FileType netrw noremap <buffer> <C-l> <C-w>l
augroup END

" ----------------------------------------------------------
" File search
" ----------------------------------------------------------
nnoremap <leader>ff :find<Space>
nnoremap <leader>fr :call <SID>OpenRecentFile()<CR>

" ----------------------------------------------------------
" Project search (pure Vim)
" ----------------------------------------------------------
function! s:SearchGlobSafe(glob) abort
    if a:glob =~# '[|[:cntrl:]]'
        echohl ErrorMsg
        echom 'Unsafe file glob. Avoid command separators and control characters.'
        echohl None
        return 0
    endif
    return 1
endfunction

function! s:SetQuickfixList(items, title) abort
    try
        call setqflist(a:items, 'r', {'title': a:title})
    catch
        call setqflist(a:items, 'r')
    endtry
endfunction

function! s:ProjectGrep(pattern, glob) abort
    let l:pattern = a:pattern
    if empty(l:pattern)
        echo 'Project search cancelled'
        return
    endif
    let l:glob = empty(a:glob) ? get(g:, 'corporate_safe_search_glob', '**/*') : a:glob
    if !s:SearchGlobSafe(l:glob)
        return
    endif

    let @/ = l:pattern
    try
        execute 'silent vimgrep /' . escape(l:pattern, '/') . '/gj ' . l:glob
    catch /^Vim\%((\a\+)\)\=:E480/
        cclose
        echom 'No project matches: ' . l:pattern . ' in ' . l:glob
        return
    catch
        echohl ErrorMsg
        echom v:exception
        echohl None
        return
    endtry

    call s:SetQuickfixList(getqflist(), 'Project search: ' . l:pattern . ' in ' . l:glob)
    copen
    wincmd p
    echom 'Project search matches: ' . len(getqflist()) . ' in ' . l:glob
endfunction

function! s:PromptProjectGrep() abort
    let l:pattern = input('Project grep: ', expand('<cword>'))
    if empty(l:pattern)
        call s:ProjectGrep('', '')
        return
    endif
    let l:glob = input('File glob: ', get(g:, 'corporate_safe_search_glob', '**/*'))
    call s:ProjectGrep(l:pattern, l:glob)
endfunction

function! s:ProjectGrepWord() abort
    let l:word = expand('<cword>')
    if empty(l:word)
        echo 'No word under cursor'
        return
    endif
    let l:glob = input('File glob: ', get(g:, 'corporate_safe_search_glob', '**/*'))
    call s:ProjectGrep('\<' . escape(l:word, '\.*$^~[]') . '\>', l:glob)
endfunction

function! s:OpenRecentFile() abort
    if empty(v:oldfiles)
        echo 'No recent files'
        return
    endif
    oldfiles
    let l:choice = input('Recent file number: ')
    if l:choice !~# '^\d\+$'
        echo 'Recent file open cancelled'
        return
    endif
    let l:index = str2nr(l:choice) - 1
    if l:index < 0 || l:index >= len(v:oldfiles)
        echo 'Recent file number out of range'
        return
    endif
    let l:file = v:oldfiles[l:index]
    if !filereadable(l:file)
        echo 'Recent file is not readable: ' . l:file
        return
    endif
    execute 'edit ' . fnameescape(l:file)
endfunction

nnoremap <leader>g :call <SID>PromptProjectGrep()<CR>
nnoremap <leader>fw :call <SID>ProjectGrepWord()<CR>

function! s:QuickfixStep(direction) abort
    try
        if a:direction > 0
            cnext
        else
            cprevious
        endif
    catch
        echohl WarningMsg
        echom v:exception
        echohl None
    endtry
endfunction

function! s:QuickfixWindow() abort
    if empty(getqflist())
        echo 'Quickfix list is empty'
        return
    endif
    cwindow
endfunction

function! s:QuickfixOpen() abort
    for l:winnr in range(1, winnr('$'))
        if getbufvar(winbufnr(l:winnr), '&buftype') ==# 'quickfix'
            return 1
        endif
    endfor
    return 0
endfunction

function! s:QuickfixToggle() abort
    if s:QuickfixOpen()
        cclose
        return
    endif
    if empty(getqflist())
        echo 'Quickfix list is empty'
        return
    endif
    copen
endfunction

function! s:QuickfixHistory(direction) abort
    try
        if a:direction > 0
            cnewer
        else
            colder
        endif
        cwindow
    catch
        echohl WarningMsg
        echom v:exception
        echohl None
    endtry
endfunction

nnoremap ]q :call <SID>QuickfixStep(1)<CR>
nnoremap [q :call <SID>QuickfixStep(-1)<CR>

nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :cclose<CR>
nnoremap <leader>qq :call <SID>QuickfixToggle()<CR>
nnoremap <leader>cw :call <SID>QuickfixWindow()<CR>
nnoremap <leader>cn :call <SID>QuickfixHistory(1)<CR>
nnoremap <leader>cp :call <SID>QuickfixHistory(-1)<CR>

" ----------------------------------------------------------
" Legacy code navigation (pure Vim heuristics)
" ----------------------------------------------------------
function! s:LegacyDefaultGlob() abort
    return get(g:, 'corporate_safe_legacy_glob', get(g:, 'corporate_safe_search_glob', '**/*'))
endfunction

function! s:LegacyPromptGlob() abort
    let l:glob = input('File glob: ', s:LegacyDefaultGlob())
    if empty(l:glob)
        echo 'Legacy search cancelled'
        return ''
    endif
    if !s:SearchGlobSafe(l:glob)
        return ''
    endif
    return l:glob
endfunction

function! s:LegacyResolveGlob(prompt) abort
    if a:prompt
        return s:LegacyPromptGlob()
    endif
    let l:glob = s:LegacyDefaultGlob()
    if !s:SearchGlobSafe(l:glob)
        return ''
    endif
    return l:glob
endfunction

function! s:LegacyResolveSymbol(arg, prompt) abort
    let l:default = empty(a:arg) ? expand('<cword>') : a:arg
    let l:symbol = empty(a:arg) ? input(a:prompt . ': ', l:default) : a:arg
    let l:symbol = substitute(l:symbol, '^\s*\|\s*$', '', 'g')
    if empty(l:symbol)
        echo 'Symbol navigation cancelled'
        return ''
    endif
    if l:symbol =~# '[[:space:][:cntrl:]|;&<>`]' || l:symbol !~# '^[A-Za-z0-9_.$#-]\+$'
        echohl WarningMsg
        echom 'Use one symbol name only. Spaces, shell characters, and paths are not accepted here.'
        echohl None
        return ''
    endif
    return l:symbol
endfunction

function! s:LegacySymbolPattern(symbol) abort
    if a:symbol !~# '^\k\+$'
        return '\V' . escape(a:symbol, '\') . '\m'
    endif
    return '\<' . escape(a:symbol, '\.*$^~[]') . '\>'
endfunction

function! s:LegacyStatementKeywordGuard() abort
    return '\%(\%(if\|for\|foreach\|while\|switch\|catch\|return\|throw\|sizeof\|typeof\|function\|def\|class\|new\|using\|include\|require\|print\|echo\)\>\)\@!'
endfunction

function! s:LegacyDefinitionPatterns(symbol) abort
    let l:word = s:LegacySymbolPattern(a:symbol)
    let l:c_like_head = s:LegacyStatementKeywordGuard() . '\%(\k\+\s\+\)\{1,6}\%([*&]\s*\)*'
    return [
        \ '\c^\s*\%(export\s\+\)\=\%(abstract\s\+\)\=class\s\+' . l:word,
        \ '\c^\s*\%(async\s\+\)\=def\s\+' . l:word . '\s*(',
        \ '\c^\s*sub\s\+' . l:word,
        \ '\c^\s*\%(export\s\+\)\=\%(async\s\+\)\=function\s\+' . l:word . '\s*(',
        \ '\c^\s*function\s\+\%(global:\|script:\|local:\)\=' . l:word,
        \ '\c^\s*\%(\%(public\|private\|protected\|static\|final\|abstract\|override\|virtual\)\s\+\)*function\s\+' . l:word . '\s*(',
        \ '\c^\s*func\s\+\%((.\{-})\s\+\)\=' . l:word . '\s*(',
        \ '\c^\s*\%(\%(public\|private\|protected\|friend\|static\)\s\+\)*\%(sub\|function\)\s\+' . l:word,
        \ '\c^\s*\%(create\|alter\)\s\+\%(or\s\+replace\s\+\)\=\%(procedure\|proc\|function\|package\)\s\+\%(\k\+\.\)\=' . l:word,
        \ '\c^\s*\%(create\|alter\)\s\+\%(procedure\|proc\|function\)\s\+\%(\[[^]]\+\]\.\)\=\[\=' . l:word . '\]\=',
        \ '\c^\s*\%(form\|method\|module\)\s\+' . l:word,
        \ '\c^\s*function\s\+' . l:word,
        \ '\c^\s*program-id\.\s\+' . l:word,
        \ '\c^\s*' . l:word . '\s\+\%(section\|paragraph\)\.',
        \ '\c^\s*' . l:word . '\.',
        \ '^\s*\%(function\s\+\)\=' . l:word . '\s*()',
        \ '\c^\s*' . l:word . '\s*[:=]\s*\%(async\s\+\)\=function\>',
        \ '\c^\s*' . l:word . '\s*[:=]\s*\%(async\s\+\)\=.\{-}=>',
        \ '\c^\s*' . l:c_like_head . l:word . '\s*(.\{-})\s*\%({\|$\)',
        \ ]
endfunction

function! s:LegacyOutlinePatterns() abort
    let l:c_like_head = s:LegacyStatementKeywordGuard() . '\%(\k\+\s\+\)\{1,6}\%([*&]\s*\)*'
    return [
        \ {'kind': 'class', 'pattern': '\c^\s*\%(export\s\+\)\=\%(abstract\s\+\)\=class\s\+\k\+'},
        \ {'kind': 'python', 'pattern': '\c^\s*\%(async\s\+\)\=def\s\+\k\+\s*('},
        \ {'kind': 'perl', 'pattern': '\c^\s*sub\s\+\k\+'},
        \ {'kind': 'function', 'pattern': '\c^\s*\%(export\s\+\)\=\%(async\s\+\)\=function\s\+\k\+\s*('},
        \ {'kind': 'powershell', 'pattern': '\c^\s*function\s\+\%(global:\|script:\|local:\)\=\k\+'},
        \ {'kind': 'method', 'pattern': '\c^\s*\%(\%(public\|private\|protected\|static\|final\|abstract\|override\|virtual\)\s\+\)*function\s\+\k\+\s*('},
        \ {'kind': 'go', 'pattern': '\c^\s*func\s\+\%((.\{-})\s\+\)\=\k\+\s*('},
        \ {'kind': 'vb', 'pattern': '\c^\s*\%(\%(public\|private\|protected\|friend\|static\)\s\+\)*\%(sub\|function\)\s\+\k\+'},
        \ {'kind': 'sql', 'pattern': '\c^\s*\%(create\|alter\)\s\+\%(or\s\+replace\s\+\)\=\%(procedure\|proc\|function\|package\)\s\+\%(\k\+\.\)\=\k\+'},
        \ {'kind': 'tsql', 'pattern': '\c^\s*\%(create\|alter\)\s\+\%(procedure\|proc\|function\)\s\+\%(\[[^]]\+\]\.\)\=\[\=\k\+\]\='},
        \ {'kind': 'abap', 'pattern': '\c^\s*\%(form\|method\|module\)\s\+\k\+'},
        \ {'kind': 'cobol-program', 'pattern': '\c^\s*program-id\.\s\+[A-Za-z0-9_-]\+'},
        \ {'kind': 'cobol-section', 'pattern': '\c^\s*[A-Za-z0-9_-]\+\s\+\%(section\|paragraph\)\.'},
        \ {'kind': 'cobol-para', 'pattern': '\c^\s*[A-Za-z0-9_-]\+\.'},
        \ {'kind': 'shell', 'pattern': '^\s*\%(function\s\+\)\=\k\+\s*()'},
        \ {'kind': 'js-prop', 'pattern': '\c^\s*\k\+\s*[:=]\s*\%(async\s\+\)\=function\>'},
        \ {'kind': 'js-arrow', 'pattern': '\c^\s*\k\+\s*[:=]\s*\%(async\s\+\)\=.\{-}=>'},
        \ {'kind': 'c-like', 'pattern': '\c^\s*' . l:c_like_head . '\k\+\s*(.\{-})\s*\%({\|$\)'},
        \ ]
endfunction

let s:legacy_call_keywords = {
    \ 'if': 1,
    \ 'for': 1,
    \ 'foreach': 1,
    \ 'while': 1,
    \ 'switch': 1,
    \ 'catch': 1,
    \ 'return': 1,
    \ 'throw': 1,
    \ 'sizeof': 1,
    \ 'typeof': 1,
    \ 'function': 1,
    \ 'def': 1,
    \ 'class': 1,
    \ 'new': 1,
    \ 'using': 1,
    \ 'include': 1,
    \ 'require': 1,
    \ 'print': 1,
    \ 'echo': 1,
    \ }

function! s:LegacyOutlineKind(text) abort
    for l:pattern in s:LegacyOutlinePatterns()
        if a:text =~# l:pattern.pattern
            return l:pattern.kind
        endif
    endfor
    return ''
endfunction

function! s:LegacySymbolFromDefinitionLine(text) abort
    let l:patterns = [
        \ '\c\<class\s\+\zs[A-Za-z0-9_.$#-]\+',
        \ '\c\<def\s\+\zs[A-Za-z0-9_.$#-]\+',
        \ '\c\<sub\s\+\zs[A-Za-z0-9_.$#-]\+',
        \ '\c\<function\s\+\%(global:\|script:\|local:\)\=\zs[A-Za-z0-9_.$#-]\+',
        \ '\c\<func\s\+\%((.\{-})\s\+\)\=\zs[A-Za-z0-9_.$#-]\+',
        \ '\c\<\%(procedure\|proc\|package\)\s\+\%(\[[^]]\+\]\.\|\k\+\.\)\=\[\=\zs[A-Za-z0-9_.$#-]\+',
        \ '\c\<\%(form\|method\|module\)\s\+\zs[A-Za-z0-9_.$#-]\+',
        \ '\c\<program-id\.\s\+\zs[A-Za-z0-9_-]\+',
        \ ]
    for l:pattern in l:patterns
        let l:match = matchstr(a:text, l:pattern)
        if !empty(l:match)
            return substitute(l:match, '[\[\]]', '', 'g')
        endif
    endfor
    if a:text =~# '\c^\s*[A-Za-z0-9_-]\+\s\+\%(section\|paragraph\)\.'
        return matchstr(a:text, '\c^\s*\zs[A-Za-z0-9_-]\+\ze\s\+\%(section\|paragraph\)\.')
    endif
    if a:text =~# '\c^\s*[A-Za-z0-9_-]\+\.'
        return matchstr(a:text, '\c^\s*\zs[A-Za-z0-9_-]\+\ze\.')
    endif
    if a:text =~# '('
        let l:head = matchstr(a:text, '^.\{-}\ze(')
        let l:match = matchstr(l:head, '[A-Za-z0-9_.$#-]\+\s*$')
        return substitute(l:match, '\s\+$', '', '')
    endif
    return ''
endfunction

function! s:LegacyCurrentContext() abort
    let l:current = line('.')
    let l:start = 0
    let l:kind = ''
    for l:lnum in reverse(range(1, l:current))
        let l:kind = s:LegacyOutlineKind(getline(l:lnum))
        if !empty(l:kind)
            let l:start = l:lnum
            break
        endif
    endfor
    if l:start == 0
        return {}
    endif

    let l:start_indent = indent(l:start)
    let l:end = line('$')
    for l:lnum in range(l:start + 1, line('$'))
        if l:kind ==# 'python' && getline(l:lnum) !~# '^\s*$' && indent(l:lnum) <= l:start_indent
            let l:end = l:lnum - 1
            break
        endif
        let l:next_kind = s:LegacyOutlineKind(getline(l:lnum))
        if !empty(l:next_kind) && indent(l:lnum) <= l:start_indent
            let l:end = l:lnum - 1
            break
        endif
    endfor

    let l:name = s:LegacySymbolFromDefinitionLine(getline(l:start))
    return {
        \ 'bufnr': bufnr('%'),
        \ 'name': empty(l:name) ? '(unknown)' : l:name,
        \ 'kind': l:kind,
        \ 'start': l:start,
        \ 'end': l:end,
        \ 'indent': l:start_indent,
        \ 'text': getline(l:start),
        \ }
endfunction

function! s:LegacyIsCommentLine(text) abort
    return a:text =~# '^\s*\(#\|//\|--\|/\*\|\*\|REM\>\|rem\>\|''\)'
endfunction

function! s:LegacyIsCallKeyword(name) abort
    let l:name = tolower(substitute(a:name, '^.\+\.', '', ''))
    return has_key(s:legacy_call_keywords, l:name)
endfunction

function! s:LegacyCallCandidatesFromLine(text, lnum) abort
    if s:LegacyIsCommentLine(a:text)
        return []
    endif

    let l:calls = []
    let l:pos = 0
    while 1
        let l:start = match(a:text, '[A-Za-z_][A-Za-z0-9_.$#]*\s*(', l:pos)
        if l:start < 0
            break
        endif
        let l:raw = matchstr(a:text, '[A-Za-z_][A-Za-z0-9_.$#]*\s*(', l:start)
        let l:name = matchstr(l:raw, '^[A-Za-z_][A-Za-z0-9_.$#]*')
        let l:pos = l:start + strlen(l:raw)
        if !empty(l:name) && !s:LegacyIsCallKeyword(l:name)
            call add(l:calls, {'name': l:name, 'col': l:start + 1})
        endif
    endwhile

    let l:legacy_patterns = [
        \ '\c\<call\s\+function\s\+\(["'']\)\=\zs[A-Za-z0-9_.$#-]\+',
        \ '\c\<call\s\+\(["'']\)\=\zs[A-Za-z0-9_.$#-]\+',
        \ '\c\<perform\s\+\zs[A-Za-z0-9_-]\+',
        \ ]
    for l:pattern in l:legacy_patterns
        let l:pos = 0
        while 1
            let l:name = matchstr(a:text, l:pattern, l:pos)
            if empty(l:name)
                break
            endif
            let l:start = match(a:text, l:pattern, l:pos)
            let l:pos = l:start + strlen(l:name)
            if !s:LegacyIsCallKeyword(l:name)
                call add(l:calls, {'name': l:name, 'col': l:start + 1})
            endif
        endwhile
    endfor

    return l:calls
endfunction

function! s:LegacyOutgoingItemsForContext(context) abort
    if empty(a:context)
        return []
    endif
    let l:items = []
    let l:start = min([a:context.start + 1, a:context.end])
    for l:lnum in range(l:start, a:context.end)
        let l:text = getline(l:lnum)
        for l:call in s:LegacyCallCandidatesFromLine(l:text, l:lnum)
            call add(l:items, {
                \ 'bufnr': bufnr('%'),
                \ 'lnum': l:lnum,
                \ 'col': l:call.col,
                \ 'type': 'C',
                \ 'text': '[callee:' . l:call.name . '] ' . l:text,
                \ })
        endfor
    endfor
    return s:DedupQuickfixItems(l:items)
endfunction

function! s:LegacyTodoSpecs() abort
    return [
        \ {'kind': 'todo', 'pattern': '\c\<\%(TODO\|FIXME\|HACK\|BUG\|XXX\|DEPRECATED\|WORKAROUND\)\>'},
        \ ]
endfunction

function! s:LegacyHotspotSpecs() abort
    return [
        \ {'kind': 'secret-literal', 'pattern': '\c\%(password\|passwd\|pwd\|secret\|api[_-]\=key\|token\)\s*[=:]\s*[''"][^''"]\+[''"]'},
        \ {'kind': 'dynamic-eval', 'pattern': '\c\<\%(eval\|execScript\|Invoke-Expression\)\s*('},
        \ {'kind': 'shell-exec', 'pattern': '\c\%(Runtime\.getRuntime\|ProcessBuilder\|shell_exec\|passthru\|Start-Process\|system\|exec\|popen\)\s*('},
        \ {'kind': 'sql-string', 'pattern': '\c[''"].*\%(select\|insert\|update\|delete\)\s\+'},
        \ {'kind': 'ssl-disabled', 'pattern': '\c\%(verify\s*=\s*false\|rejectUnauthorized\s*:\s*false\|SSL_VERIFYPEER.\{-}false\|ssl_verify_none\)'},
        \ {'kind': 'debug-leftover', 'pattern': '\c\%(debugger\|console\.log\|printStackTrace\|var_dump\|dd\)\s*('},
        \ {'kind': 'broad-catch', 'pattern': '\c\<except\s*:\|catch\s*(.\{-})'},
        \ {'kind': 'unsafe-temp', 'pattern': '\c\%(/tmp/\|mktemp\|tempnam\)'},
        \ ]
endfunction

function! s:QuickfixItemKey(item) abort
    let l:bufnr = get(a:item, 'bufnr', 0)
    let l:name = get(a:item, 'filename', '')
    if empty(l:name) && l:bufnr > 0
        let l:name = bufname(l:bufnr)
    endif
    return l:name . ':' . get(a:item, 'lnum', 0) . ':' . get(a:item, 'col', 0) . ':' . get(a:item, 'text', '')
endfunction

function! s:QuickfixLineKey(item) abort
    let l:bufnr = get(a:item, 'bufnr', 0)
    let l:name = get(a:item, 'filename', '')
    if empty(l:name) && l:bufnr > 0
        let l:name = bufname(l:bufnr)
    endif
    return l:name . ':' . get(a:item, 'lnum', 0)
endfunction

function! s:DedupQuickfixItems(items) abort
    let l:seen = {}
    let l:deduped = []
    for l:item in a:items
        let l:key = s:QuickfixItemKey(l:item)
        if has_key(l:seen, l:key)
            continue
        endif
        let l:seen[l:key] = 1
        call add(l:deduped, l:item)
    endfor
    return l:deduped
endfunction

function! s:DecorateQuickfixItems(items, kind, type) abort
    let l:decorated = []
    for l:item in a:items
        let l:copy = copy(l:item)
        let l:copy.type = a:type
        let l:copy.text = '[' . a:kind . '] ' . get(l:copy, 'text', '')
        call add(l:decorated, l:copy)
    endfor
    return l:decorated
endfunction

function! s:CollectVimgrepItems(patterns, glob, kind, type) abort
    let l:items = []
    for l:pattern in a:patterns
        try
            execute 'silent vimgrep /' . escape(l:pattern, '/') . '/gj ' . a:glob
        catch /^Vim\%((\a\+)\)\=:E480/
            continue
        catch
            echohl ErrorMsg
            echom v:exception
            echohl None
            return []
        endtry
        call extend(l:items, s:DecorateQuickfixItems(getqflist(), a:kind, a:type))
    endfor
    return s:DedupQuickfixItems(l:items)
endfunction

function! s:CollectLegacyPatternItems(specs, glob, type) abort
    let l:items = []
    for l:spec in a:specs
        try
            execute 'silent vimgrep /' . escape(l:spec.pattern, '/') . '/gj ' . a:glob
        catch /^Vim\%((\a\+)\)\=:E480/
            continue
        catch
            echohl ErrorMsg
            echom v:exception
            echohl None
            return []
        endtry
        call extend(l:items, s:DecorateQuickfixItems(getqflist(), l:spec.kind, a:type))
    endfor
    return s:DedupQuickfixItems(l:items)
endfunction

function! s:ShowQuickfixItems(items, title, empty_message) abort
    call s:SetQuickfixList(a:items, a:title)
    if empty(a:items)
        cclose
        echom a:empty_message
        return 0
    endif
    copen
    wincmd p
    echom a:title . ': ' . len(a:items)
    return 1
endfunction

function! s:QuickfixItemLocation(item) abort
    let l:bufnr = get(a:item, 'bufnr', 0)
    let l:name = get(a:item, 'filename', '')
    if empty(l:name) && l:bufnr > 0
        let l:name = bufname(l:bufnr)
    endif
    if empty(l:name)
        let l:name = '[buffer]'
    else
        let l:name = fnamemodify(l:name, ':.')
    endif
    return l:name . ':' . get(a:item, 'lnum', 0)
endfunction

function! s:QuickfixReportLines(title, items, limit) abort
    let l:lines = [a:title . ' (' . len(a:items) . ')']
    if empty(a:items)
        call add(l:lines, '  none')
        return l:lines
    endif
    let l:count = 0
    for l:item in a:items
        let l:count += 1
        if l:count > a:limit
            call add(l:lines, '  ... ' . (len(a:items) - a:limit) . ' more')
            break
        endif
        call add(l:lines, '  ' . s:QuickfixItemLocation(l:item) . ': ' . get(l:item, 'text', ''))
    endfor
    return l:lines
endfunction

function! s:ShowLegacyScratch(name, lines) abort
    botright new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
    execute 'file ' . fnameescape(a:name)
    call setline(1, empty(a:lines) ? ['(no output)'] : a:lines)
    nnoremap <buffer> q :close<CR>
    setlocal nomodifiable nomodified readonly
    normal! gg
endfunction

function! s:LegacyOutline() abort
    if line('$') == 1 && empty(getline(1)) && empty(expand('%:p'))
        echo 'No file content to outline'
        return
    endif

    let l:items = []
    let l:patterns = s:LegacyOutlinePatterns()
    for l:lnum in range(1, line('$'))
        let l:text = getline(l:lnum)
        for l:pattern in l:patterns
            if l:text =~# l:pattern.pattern
                let l:col = match(l:text, '\S') + 1
                if l:col <= 0
                    let l:col = 1
                endif
                call add(l:items, {
                    \ 'bufnr': bufnr('%'),
                    \ 'lnum': l:lnum,
                    \ 'col': l:col,
                    \ 'type': 'O',
                    \ 'text': '[' . l:pattern.kind . '] ' . l:text,
                    \ })
                break
            endif
        endfor
    endfor
    call s:ShowQuickfixItems(l:items, 'Legacy outline', 'No likely functions or classes found in current file.')
endfunction

function! s:LegacyDefinitions(arg) abort
    let l:symbol = s:LegacyResolveSymbol(a:arg, 'Definition symbol')
    if empty(l:symbol)
        return
    endif
    let l:glob = s:LegacyResolveGlob(empty(a:arg))
    if empty(l:glob)
        return
    endif
    let l:items = s:CollectVimgrepItems(s:LegacyDefinitionPatterns(l:symbol), l:glob, 'definition', 'D')
    call s:ShowQuickfixItems(l:items, 'Likely definitions for ' . l:symbol, 'No likely definitions found for: ' . l:symbol)
endfunction

function! s:LegacyReferences(arg) abort
    let l:symbol = s:LegacyResolveSymbol(a:arg, 'Reference symbol')
    if empty(l:symbol)
        return
    endif
    let l:glob = s:LegacyResolveGlob(empty(a:arg))
    if empty(l:glob)
        return
    endif
    let l:items = s:CollectVimgrepItems([s:LegacySymbolPattern(l:symbol)], l:glob, 'reference', 'R')
    call s:ShowQuickfixItems(l:items, 'References for ' . l:symbol, 'No references found for: ' . l:symbol)
endfunction

function! s:LegacyFlow(arg) abort
    let l:symbol = s:LegacyResolveSymbol(a:arg, 'Flow symbol')
    if empty(l:symbol)
        return
    endif
    let l:glob = s:LegacyResolveGlob(empty(a:arg))
    if empty(l:glob)
        return
    endif

    let l:definitions = s:CollectVimgrepItems(s:LegacyDefinitionPatterns(l:symbol), l:glob, 'definition', 'D')
    let l:references = s:CollectVimgrepItems([s:LegacySymbolPattern(l:symbol)], l:glob, 'reference', 'R')
    let l:definition_lines = {}
    for l:item in l:definitions
        let l:definition_lines[s:QuickfixLineKey(l:item)] = 1
    endfor

    let l:items = copy(l:definitions)
    for l:item in l:references
        if has_key(l:definition_lines, s:QuickfixLineKey(l:item))
            continue
        endif
        call add(l:items, l:item)
    endfor
    let l:items = s:DedupQuickfixItems(l:items)
    call s:ShowQuickfixItems(l:items, 'Symbol flow for ' . l:symbol, 'No definitions or references found for: ' . l:symbol)
endfunction

function! s:LegacyOutgoingCalls() abort
    let l:context = s:LegacyCurrentContext()
    if empty(l:context)
        echohl WarningMsg
        echom 'No current function/class context found. Move the cursor inside a likely function first.'
        echohl None
        return
    endif
    let l:items = s:LegacyOutgoingItemsForContext(l:context)
    call s:ShowQuickfixItems(l:items, 'Outgoing calls from ' . l:context.name, 'No likely outgoing calls found in: ' . l:context.name)
endfunction

function! s:LegacyInspect(arg) abort
    let l:symbol = s:LegacyResolveSymbol(a:arg, 'Inspect symbol')
    if empty(l:symbol)
        return
    endif
    let l:glob = s:LegacyResolveGlob(empty(a:arg))
    if empty(l:glob)
        return
    endif

    let l:context = s:LegacyCurrentContext()
    let l:definitions = s:CollectVimgrepItems(s:LegacyDefinitionPatterns(l:symbol), l:glob, 'definition', 'D')
    let l:references = s:CollectVimgrepItems([s:LegacySymbolPattern(l:symbol)], l:glob, 'reference', 'R')
    let l:outgoing = s:LegacyOutgoingItemsForContext(l:context)
    let l:lines = [
        \ 'Legacy Symbol Inspection',
        \ '',
        \ 'Symbol: ' . l:symbol,
        \ 'File glob: ' . l:glob,
        \ 'Current file: ' . (empty(expand('%:p')) ? '[no file]' : fnamemodify(expand('%:p'), ':.')),
        \ ]
    if empty(l:context)
        call extend(l:lines, ['Current context: none found', ''])
    else
        call extend(l:lines, [
            \ 'Current context: ' . l:context.kind . ' ' . l:context.name . ' lines ' . l:context.start . '-' . l:context.end,
            \ 'Context line: ' . l:context.text,
            \ '',
            \ ])
    endif
    call extend(l:lines, s:QuickfixReportLines('Likely definitions', l:definitions, 12))
    call add(l:lines, '')
    call extend(l:lines, s:QuickfixReportLines('References / callers', l:references, 20))
    call add(l:lines, '')
    call extend(l:lines, s:QuickfixReportLines('Likely outgoing calls in current context', l:outgoing, 20))
    call extend(l:lines, [
        \ '',
        \ 'Workflow',
        \ '  Use Space fd to jump to likely definitions.',
        \ '  Use Space fc to step through callers/references.',
        \ '  Use Space fO inside a function to inspect callees.',
        \ '  Use ]q and [q to move through quickfix results.',
        \ '',
        \ 'Press q to close this report.',
        \ ])
    call s:ShowLegacyScratch('Corporate-Safe-Legacy-Inspection', l:lines)
endfunction

function! s:LegacyTodos(arg) abort
    let l:glob = empty(a:arg) ? s:LegacyDefaultGlob() : a:arg
    if empty(l:glob) || !s:SearchGlobSafe(l:glob)
        return
    endif
    let l:items = s:CollectLegacyPatternItems(s:LegacyTodoSpecs(), l:glob, 'T')
    call s:ShowQuickfixItems(l:items, 'TODO markers', 'No TODO/FIXME/HACK/BUG markers found in: ' . l:glob)
endfunction

function! s:LegacyTodosPrompt() abort
    let l:glob = s:LegacyPromptGlob()
    if empty(l:glob)
        return
    endif
    call s:LegacyTodos(l:glob)
endfunction

function! s:LegacyHotspots(arg) abort
    let l:glob = empty(a:arg) ? s:LegacyDefaultGlob() : a:arg
    if empty(l:glob) || !s:SearchGlobSafe(l:glob)
        return
    endif
    let l:items = s:CollectLegacyPatternItems(s:LegacyHotspotSpecs(), l:glob, 'H')
    call s:ShowQuickfixItems(l:items, 'Legacy hotspots', 'No legacy hotspot patterns found in: ' . l:glob)
endfunction

function! s:LegacyHotspotsPrompt() abort
    let l:glob = s:LegacyPromptGlob()
    if empty(l:glob)
        return
    endif
    call s:LegacyHotspots(l:glob)
endfunction

function! s:FindUpwardTags(start) abort
    let l:start = empty(a:start) ? getcwd() : a:start
    let l:found = findfile('tags', fnamemodify(l:start, ':p') . ';')
    return empty(l:found) ? '' : fnamemodify(l:found, ':p')
endfunction

function! s:LegacyTagsHealth() abort
    let l:file_dir = empty(expand('%:p')) ? '' : expand('%:p:h')
    let l:tagfiles = exists('*tagfiles') ? tagfiles() : []
    let l:lines = [
        \ 'Corporate-Safe Vim Tags Health',
        \ '',
        \ 'Tags option: ' . &tags,
        \ 'Current file: ' . (empty(expand('%:p')) ? '[no file]' : fnamemodify(expand('%:p'), ':.')),
        \ 'Current file upward tags: ' . (empty(l:file_dir) ? '[no file]' : (empty(s:FindUpwardTags(l:file_dir)) ? 'not found' : fnamemodify(s:FindUpwardTags(l:file_dir), ':.'))),
        \ 'Working directory upward tags: ' . (empty(s:FindUpwardTags(getcwd())) ? 'not found' : fnamemodify(s:FindUpwardTags(getcwd()), ':.')),
        \ '',
        \ 'Resolved tag files',
        \ ]
    if empty(l:tagfiles)
        call add(l:lines, '  none resolved yet')
    else
        for l:file in l:tagfiles
            call add(l:lines, '  ' . fnamemodify(l:file, ':.'))
        endfor
    endif
    call extend(l:lines, [
        \ '',
        \ 'Usage',
        \ '  Space ft or :CorporateSafeTag {name} jumps through existing tags.',
        \ '  This vimrc does not generate tags; use an approved ctags tool if your workplace allows it.',
        \ '',
        \ 'Press q to close this report.',
        \ ])
    call s:ShowLegacyScratch('Corporate-Safe-Tags-Health', l:lines)
endfunction

function! s:LegacyTagJump(arg) abort
    let l:symbol = s:LegacyResolveSymbol(a:arg, 'Tag symbol')
    if empty(l:symbol)
        return
    endif
    try
        let l:matches = taglist('^' . escape(l:symbol, '\.^$~[]') . '$')
    catch
        let l:matches = []
    endtry
    if empty(l:matches)
        echohl WarningMsg
        echom 'No tag matches found for ' . l:symbol . '. Generate a tags file with your approved ctags tool, then retry.'
        echohl None
        return
    endif
    execute 'tjump ' . l:symbol
endfunction

command! CorporateSafeOutline call <SID>LegacyOutline()
command! -nargs=? CorporateSafeDefinitions call <SID>LegacyDefinitions(<q-args>)
command! -nargs=? CorporateSafeReferences call <SID>LegacyReferences(<q-args>)
command! -nargs=? CorporateSafeCallers call <SID>LegacyReferences(<q-args>)
command! -nargs=? CorporateSafeFlow call <SID>LegacyFlow(<q-args>)
command! CorporateSafeOutgoing call <SID>LegacyOutgoingCalls()
command! -nargs=? CorporateSafeInspect call <SID>LegacyInspect(<q-args>)
command! -nargs=? CorporateSafeTodos call <SID>LegacyTodos(<q-args>)
command! -nargs=? CorporateSafeHotspots call <SID>LegacyHotspots(<q-args>)
command! -nargs=? CorporateSafeTag call <SID>LegacyTagJump(<q-args>)
command! CorporateSafeTagsHealth call <SID>LegacyTagsHealth()

nnoremap <leader>fo :call <SID>LegacyOutline()<CR>
nnoremap <leader>fd :call <SID>LegacyDefinitions('')<CR>
nnoremap <leader>fc :call <SID>LegacyReferences('')<CR>
nnoremap <leader>fF :call <SID>LegacyFlow('')<CR>
nnoremap <leader>fO :call <SID>LegacyOutgoingCalls()<CR>
nnoremap <leader>fI :call <SID>LegacyInspect('')<CR>
nnoremap <leader>fT :call <SID>LegacyTodosPrompt()<CR>
nnoremap <leader>fh :call <SID>LegacyHotspotsPrompt()<CR>
nnoremap <leader>ft :call <SID>LegacyTagJump('')<CR>
nnoremap <leader>fH :call <SID>LegacyTagsHealth()<CR>

" ----------------------------------------------------------
" Git workflow (optional, stock Vim wrapper around git)
" ----------------------------------------------------------
function! s:SystemList(command) abort
    if exists('*systemlist')
        return systemlist(a:command)
    endif
    return split(system(a:command), "\n")
endfunction

function! s:GitExecutableStatus() abort
    return executable('git') ? 'available' : 'unavailable'
endfunction

function! s:GitAvailable(show_message) abort
    if executable('git')
        return 1
    endif
    if a:show_message
        echohl WarningMsg
        echom 'Git is unavailable: no git executable found in PATH.'
        echohl None
    endif
    return 0
endfunction

function! s:GitWorkingDir() abort
    let l:dir = expand('%:p:h')
    if empty(l:dir) || !isdirectory(l:dir)
        let l:dir = getcwd()
    endif
    return l:dir
endfunction

function! s:GitRoot() abort
    if !s:GitAvailable(0)
        return ''
    endif
    let l:dir = s:GitWorkingDir()
    let l:cmd = 'git -C ' . shellescape(l:dir) . ' rev-parse --show-toplevel'
    let l:lines = s:SystemList(l:cmd)
    if v:shell_error != 0 || empty(l:lines)
        return ''
    endif
    for l:line in reverse(copy(l:lines))
        if !empty(l:line) && l:line !~# '^warning:'
            return s:NormalizePath(l:line)
        endif
    endfor
    return ''
endfunction

function! s:GitRootStatus() abort
    if !s:GitAvailable(0)
        return 'unavailable'
    endif
    let l:root = s:GitRoot()
    return empty(l:root) ? 'not inside a git repo' : fnamemodify(l:root, ':~')
endfunction

function! s:GitRequireRoot() abort
    let l:root = s:GitRoot()
    if !empty(l:root)
        return l:root
    endif
    if s:GitAvailable(1)
        echohl WarningMsg
        echom 'Git repository not detected for the current buffer or working directory.'
        echohl None
    endif
    return ''
endfunction

function! s:GitOutputBufferName(title) abort
    return 'Corporate-Safe-Git-' . substitute(a:title, '[^A-Za-z0-9._-]', '-', 'g')
endfunction

function! s:ShowOutputBuffer(name, lines) abort
    botright new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
    execute 'file ' . fnameescape(a:name)
    call setline(1, empty(a:lines) ? ['(no output)'] : a:lines)
    nnoremap <buffer> q :close<CR>
    setlocal nomodifiable nomodified readonly
    normal! gg
endfunction

function! s:GitOutput(args, title) abort
    let l:root = s:GitRequireRoot()
    if empty(l:root)
        return 0
    endif
    let l:args = empty(a:args) ? 'status --short --branch' : a:args
    if l:args =~# '[[:cntrl:]]'
        echohl ErrorMsg
        echom 'Unsafe git arguments: control characters are not allowed.'
        echohl None
        return 0
    endif

    let l:cmd = 'git -C ' . shellescape(l:root) . ' -c color.ui=false --no-pager ' . l:args
    let l:lines = s:SystemList(l:cmd)
    let l:exit = v:shell_error
    if empty(l:lines)
        let l:lines = [l:exit == 0 ? 'Done.' : '(no output)']
    endif
    call s:ShowOutputBuffer(s:GitOutputBufferName(a:title), [
        \ '$ ' . l:cmd,
        \ 'Repository: ' . fnamemodify(l:root, ':~'),
        \ 'Exit: ' . l:exit,
        \ '',
        \ ] + l:lines)
    return l:exit == 0
endfunction

function! s:GitShell(args) abort
    let l:root = s:GitRequireRoot()
    if empty(l:root)
        return
    endif
    execute '!git -C ' . shellescape(l:root) . ' ' . a:args
endfunction

function! s:GitPathWithSlashes(path) abort
    let l:path = fnamemodify(a:path, ':p')
    if exists('*resolve')
        let l:path = resolve(l:path)
    endif
    let l:path = simplify(l:path)
    let l:path = substitute(l:path, '\\', '/', 'g')
    if l:path !~# '^\a:/$' && l:path !=# '/'
        let l:path = substitute(l:path, '/\+$', '', '')
    endif
    return l:path
endfunction

function! s:GitRelativeFile() abort
    let l:file = expand('%:p')
    if empty(l:file)
        echo 'No file path for current buffer'
        return ''
    endif
    let l:root = s:GitRequireRoot()
    if empty(l:root)
        return ''
    endif

    let l:file_path = s:GitPathWithSlashes(l:file)
    let l:root_path = s:GitPathWithSlashes(l:root)
    let l:file_cmp = (has('win32') || has('win64')) ? tolower(l:file_path) : l:file_path
    let l:root_cmp = (has('win32') || has('win64')) ? tolower(l:root_path) : l:root_path
    if stridx(l:file_cmp, l:root_cmp . '/') != 0
        echohl WarningMsg
        echom 'Current file is outside the git repository root.'
        echohl None
        return ''
    endif
    return strpart(l:file_path, strlen(l:root_path) + 1)
endfunction

function! s:GitStatus() abort
    call s:GitOutput('status --short --branch', 'Status')
endfunction

function! s:GitChangedFiles() abort
    let l:root = s:GitRequireRoot()
    if empty(l:root)
        return
    endif
    let l:cmd = 'git -C ' . shellescape(l:root) . ' -c color.ui=false -c core.quotePath=false status --porcelain'
    let l:lines = s:SystemList(l:cmd)
    if v:shell_error != 0
        call s:GitOutput('status --short --branch', 'Status')
        return
    endif

    let l:items = []
    for l:line in l:lines
        if len(l:line) < 4 || l:line =~# '^warning:'
            continue
        endif
        let l:path = strpart(l:line, 3)
        if l:path =~# ' -> '
            let l:path = matchstr(l:path, ' -> \zs.*')
        endif
        if empty(l:path)
            continue
        endif
        call add(l:items, {
            \ 'filename': l:root . '/' . l:path,
            \ 'lnum': 1,
            \ 'col': 1,
            \ 'text': l:line[0:1] . ' ' . l:path,
            \ })
    endfor

    call s:SetQuickfixList(l:items, 'Git changed files')
    if empty(l:items)
        cclose
        echom 'No changed git files.'
        return
    endif
    copen
endfunction

function! s:GitDiffFile() abort
    let l:file = s:GitRelativeFile()
    if empty(l:file)
        return
    endif
    call s:GitOutput('diff -- ' . shellescape(l:file), 'Diff')
endfunction

function! s:GitDiffStagedFile() abort
    let l:file = s:GitRelativeFile()
    if empty(l:file)
        return
    endif
    call s:GitOutput('diff --staged -- ' . shellescape(l:file), 'Staged-Diff')
endfunction

function! s:GitLog() abort
    call s:GitOutput('log --oneline --decorate --graph -30', 'Log')
endfunction

function! s:GitBlameFile() abort
    let l:file = s:GitRelativeFile()
    if empty(l:file)
        return
    endif
    call s:GitOutput('blame --date=short -- ' . shellescape(l:file), 'Blame')
endfunction

function! s:GitStageFile() abort
    let l:file = s:GitRelativeFile()
    if empty(l:file)
        return
    endif
    call s:GitOutput('add -- ' . shellescape(l:file), 'Stage-File')
endfunction

function! s:GitStageAll() abort
    if confirm('Stage all git changes?', "&Stage all\n&Cancel", 2) != 1
        echo 'Stage all cancelled'
        return
    endif
    call s:GitOutput('add -A', 'Stage-All')
endfunction

function! s:GitUnstageFile() abort
    let l:file = s:GitRelativeFile()
    if empty(l:file)
        return
    endif
    call s:GitOutput('restore --staged -- ' . shellescape(l:file), 'Unstage-File')
endfunction

function! s:GitUnstageAll() abort
    if confirm('Unstage all git changes?', "&Unstage all\n&Cancel", 2) != 1
        echo 'Unstage all cancelled'
        return
    endif
    call s:GitOutput('restore --staged .', 'Unstage-All')
endfunction

function! s:GitCommitPrompt() abort
    let l:message = input('Commit message: ')
    if empty(l:message)
        echo 'Commit cancelled'
        return
    endif
    call s:GitOutput('commit -m ' . shellescape(l:message), 'Commit')
endfunction

function! s:GitRestoreFile() abort
    let l:file = s:GitRelativeFile()
    if empty(l:file)
        return
    endif
    if confirm('Restore current file from HEAD?', "&Restore\n&Cancel", 2) != 1
        echo 'Restore cancelled'
        return
    endif
    call s:GitOutput('restore -- ' . shellescape(l:file), 'Restore-File')
    checktime
endfunction

function! s:GitUserArgsSafe(args) abort
    return a:args !~# '[|;&<>`]' && a:args !~# '\$('
endfunction

function! s:GitCommand(args) abort
    if !empty(a:args) && !s:GitUserArgsSafe(a:args)
        echohl ErrorMsg
        echom 'Unsafe git arguments. Run shell pipes, redirects, and command separators outside :Git.'
        echohl None
        return
    endif
    call s:GitOutput(a:args, empty(a:args) ? 'Status' : 'Command')
endfunction

command! -nargs=* CorporateSafeGit call <SID>GitCommand(<q-args>)
command! CorporateSafeGitStatus call <SID>GitStatus()
command! CorporateSafeGitChangedFiles call <SID>GitChangedFiles()
command! CorporateSafeGitDiff call <SID>GitDiffFile()
command! CorporateSafeGitStagedDiff call <SID>GitDiffStagedFile()
command! CorporateSafeGitLog call <SID>GitLog()
command! CorporateSafeGitBlame call <SID>GitBlameFile()
command! CorporateSafeGitStage call <SID>GitStageFile()
command! CorporateSafeGitStageAll call <SID>GitStageAll()
command! CorporateSafeGitUnstage call <SID>GitUnstageFile()
command! CorporateSafeGitUnstageAll call <SID>GitUnstageAll()
command! CorporateSafeGitCommit call <SID>GitCommitPrompt()
command! CorporateSafeGitRestore call <SID>GitRestoreFile()

if exists(':Git') != 2 || get(g:, 'corporate_safe_git_command_owner', '') ==# 'corporate-safe-vim'
    command! -nargs=* Git call <SID>GitCommand(<q-args>)
    let g:corporate_safe_git_command_owner = 'corporate-safe-vim'
endif

nnoremap <silent> <leader>Gs :call <SID>GitStatus()<CR>
nnoremap <silent> <leader>Gq :call <SID>GitChangedFiles()<CR>
nnoremap <silent> <leader>Gd :call <SID>GitDiffFile()<CR>
nnoremap <silent> <leader>GD :call <SID>GitDiffStagedFile()<CR>
nnoremap <silent> <leader>Gl :call <SID>GitLog()<CR>
nnoremap <silent> <leader>Gb :call <SID>GitBlameFile()<CR>
nnoremap <silent> <leader>Ga :call <SID>GitStageFile()<CR>
nnoremap <silent> <leader>GA :call <SID>GitStageAll()<CR>
nnoremap <silent> <leader>Gu :call <SID>GitUnstageFile()<CR>
nnoremap <silent> <leader>GU :call <SID>GitUnstageAll()<CR>
nnoremap <silent> <leader>Gc :call <SID>GitCommitPrompt()<CR>
nnoremap <silent> <leader>Gp :call <SID>GitShell('push')<CR>
nnoremap <silent> <leader>GP :call <SID>GitShell('pull --ff-only')<CR>
nnoremap <silent> <leader>Gr :call <SID>GitRestoreFile()<CR>
nnoremap <leader>Gg :Git<Space>

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
set nolist
set listchars=tab:»·,trail:·,nbsp:␣
nnoremap <leader>l :set list!<CR>

" ----------------------------------------------------------
" Manual cleanup
" ----------------------------------------------------------
function! s:TrimTrailingWhitespace() abort
    if &modifiable == 0 || &readonly
        echohl WarningMsg
        echom 'Trailing whitespace not trimmed: buffer is not editable.'
        echohl None
        return
    endif
    let l:view = winsaveview()
    let l:changedtick = b:changedtick
    try
        keepjumps keeppatterns %s/\s\+$//e
    catch
        call winrestview(l:view)
        echohl ErrorMsg
        echom 'Trailing whitespace trim failed: ' . v:exception
        echohl None
        return
    endtry
    call winrestview(l:view)
    if b:changedtick == l:changedtick
        echom 'No trailing whitespace found.'
    else
        echom 'Trailing whitespace trimmed.'
    endif
endfunction

command! CorporateSafeTrimWhitespace call <SID>TrimTrailingWhitespace()
nnoremap <leader>tw :call <SID>TrimTrailingWhitespace()<CR>

" ----------------------------------------------------------
" Yank highlight and wrap
" ----------------------------------------------------------
let s:yank_match_id = -1

function! s:ClearYankHighlight(timer) abort
    if s:yank_match_id != -1
        silent! call matchdelete(s:yank_match_id)
        let s:yank_match_id = -1
    endif
endfunction

function! s:HighlightYank() abort
    if !exists('*matchaddpos') || !exists('*timer_start')
        return
    endif
    if s:yank_match_id != -1
        silent! call matchdelete(s:yank_match_id)
        let s:yank_match_id = -1
    endif
    let l:start = getpos("'[")
    let l:end = getpos("']")
    if l:start[1] <= 0 || l:end[1] <= 0
        return
    endif
    let l:positions = []
    let l:last_line = min([l:end[1], l:start[1] + 80])
    for l:lnum in range(l:start[1], l:last_line)
        if l:lnum == l:start[1] && l:lnum == l:end[1]
            call add(l:positions, [l:lnum, l:start[2], max([1, l:end[2] - l:start[2] + 1])])
        elseif l:lnum == l:start[1]
            call add(l:positions, [l:lnum, l:start[2]])
        elseif l:lnum == l:end[1]
            call add(l:positions, [l:lnum, 1, max([1, l:end[2]])])
        else
            call add(l:positions, [l:lnum])
        endif
    endfor
    if !empty(l:positions)
        let s:yank_match_id = matchaddpos('IncSearch', l:positions, 10)
        call timer_start(180, function('<SID>ClearYankHighlight'))
    endif
endfunction

augroup HighlightYank
    autocmd!
    if exists('##TextYankPost')
        autocmd TextYankPost * silent! call s:HighlightYank()
    endif
augroup END

nnoremap <leader>z :set wrap!<CR>

" ----------------------------------------------------------
" Statusline
" ----------------------------------------------------------
function! s:StatuslineEncoding() abort
    return empty(&fileencoding) ? &encoding : &fileencoding
endfunction

execute 'set statusline=%f\ %m%r\ [%Y]\ %{'.expand('<SID>').'StatuslineEncoding()}\ %{&fileformat}\ %=%l:%c\ (%p%%)'

" ----------------------------------------------------------
" Sessions
" ----------------------------------------------------------
" Keep buffers, window layout, tabs, and folds in per-project sessions.
set sessionoptions=buffers,curdir,folds,tabpages,winsize,winpos

let s:auto_session_root = ''
let s:startup_root = ''
let s:last_session_save_status = 'not saved yet'
let s:last_session_restore_status = 'not restored yet'

" Auto-restore session when Vim starts with no file args, or with only a directory arg.
" Auto-save session on exit in those same cases.
function! s:ShouldAutoSession() abort
    if get(g:, 'corporate_safe_no_local_state', 0)
        return 0
    endif
    if !get(g:, 'corporate_safe_auto_sessions', 1)
        return 0
    endif
    if argc() == 0
        return 1
    endif
    " Single argument that is a directory (e.g. vim .)
    if argc() == 1 && isdirectory(argv(0))
        return 1
    endif
    return 0
endfunction

function! s:NormalizePath(path) abort
    let l:path = fnamemodify(a:path, ':p')
    if exists('*resolve')
        let l:path = resolve(l:path)
    endif
    let l:path = simplify(l:path)
    let l:path = substitute(l:path, '\\', '/', 'g')
    if l:path !~# '^\a:/$' && l:path !=# '/'
        let l:path = substitute(l:path, '/\+$', '', '')
    endif
    if has('win32') || has('win64')
        let l:path = tolower(l:path)
    endif
    return l:path
endfunction

function! s:SessionRootFromStartup() abort
    if argc() == 1 && isdirectory(argv(0))
        return s:NormalizePath(argv(0))
    endif
    return s:NormalizePath(getcwd())
endfunction

function! s:ProjectRoot() abort
    if !empty(s:auto_session_root)
        return s:auto_session_root
    endif
    if empty(s:startup_root)
        let s:startup_root = s:SessionRootFromStartup()
    endif
    return s:startup_root
endfunction

function! s:FindProjectExplorerWindow() abort
    let l:fallback = 0
    for l:winnr in range(1, winnr('$'))
        let l:buf = winbufnr(l:winnr)
        if getwinvar(l:winnr, 'corporate_safe_project_explorer', 0)
            return l:winnr
        endif
        if l:fallback == 0 && getbufvar(l:buf, '&filetype') ==# 'netrw'
            let l:fallback = l:winnr
        endif
    endfor
    return l:fallback
endfunction

function! s:CloseProjectExplorer(winnr) abort
    let l:current = exists('*win_getid') ? win_getid() : 0
    execute a:winnr . 'wincmd w'
    if winnr('$') > 1
        close
    else
        enew
    endif
    if l:current != 0 && win_gotoid(l:current)
        return
    endif
    silent! wincmd p
endfunction

function! s:OpenProjectExplorer() abort
    let l:explorer = s:FindProjectExplorerWindow()
    if l:explorer > 0
        call s:CloseProjectExplorer(l:explorer)
        return
    endif

    let l:current = exists('*win_getid') ? win_getid() : 0
    try
        execute 'silent keepalt Lexplore ' . fnameescape(s:ProjectRoot())
    catch
        echohl ErrorMsg
        echom 'Project explorer failed: ' . v:exception
        echohl None
        return
    endtry

    let l:explorer = s:FindProjectExplorerWindow()
    if l:explorer > 0
        call setwinvar(l:explorer, 'corporate_safe_project_explorer', 1)
        call setwinvar(l:explorer, '&winfixwidth', 1)
    endif
    if l:current != 0
        call win_gotoid(l:current)
    endif
endfunction

function! s:CurrentSessionRoot() abort
    if !empty(s:auto_session_root)
        return s:auto_session_root
    endif
    return s:NormalizePath(getcwd())
endfunction

function! s:SessionKey(path) abort
    let l:tail = fnamemodify(a:path, ':t')
    if empty(l:tail)
        if a:path =~# '^\a:/$'
            let l:tail = substitute(a:path, '[:/\\]', '', 'g')
        else
            let l:tail = 'root'
        endif
    endif
    let l:tail = substitute(l:tail, '[^A-Za-z0-9._-]', '_', 'g')
    if exists('*sha256')
        let l:key = sha256(a:path)[0:15]
    else
        let l:key = substitute(a:path, '[^A-Za-z0-9._-]', '_', 'g')
    endif
    return l:tail . '__' . l:key
endfunction

function! s:CurrentSessionFile() abort
    if empty(s:session_dir)
        return ''
    endif
    return s:session_dir . '/' . s:SessionKey(s:CurrentSessionRoot()) . '.vim'
endfunction

function! s:SessionAvailable(show_messages) abort
    if get(g:, 'corporate_safe_no_local_state', 0)
        if a:show_messages
            echohl WarningMsg
            echom 'Sessions unavailable: local state writes are disabled.'
            echohl None
        endif
        return 0
    endif
    if !empty(s:session_dir) && isdirectory(s:session_dir)
        return 1
    endif
    if a:show_messages
        echohl WarningMsg
        echom 'Sessions unavailable: session directory could not be created.'
        echohl None
    endif
    return 0
endfunction

function! s:IsTerminalBuffer(bufnr) abort
    if !bufexists(a:bufnr)
        return 0
    endif
    let l:name = bufname(a:bufnr)
    let l:bt = getbufvar(a:bufnr, '&buftype')
    return l:bt ==# 'terminal' || l:name =~# '^term://'
endfunction

function! s:HasTerminalBuffers() abort
    for l:buf in range(1, bufnr('$'))
        if s:IsTerminalBuffer(l:buf)
            return 1
        endif
    endfor
    return 0
endfunction

function! s:DropTerminalBuffers() abort
    for l:buf in range(1, bufnr('$'))
        if s:IsTerminalBuffer(l:buf)
            silent! execute 'bwipeout! ' . l:buf
        endif
    endfor
endfunction

function! s:CleanMissingBuffers() abort
    for l:buf in range(1, bufnr('$'))
        if !bufexists(l:buf)
            continue
        endif
        let l:name = bufname(l:buf)
        let l:ft   = getbufvar(l:buf, '&filetype')
        let l:bt   = getbufvar(l:buf, '&buftype')

        " Wipe terminal buffers
        if s:IsTerminalBuffer(l:buf)
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

function! s:SaveCurrentSession(force_for_exit) abort
    if !s:SessionAvailable(!a:force_for_exit)
        let s:last_session_save_status = get(g:, 'corporate_safe_no_local_state', 0) ? 'disabled: no local state' : 'unavailable: session directory missing'
        return
    endif
    let l:session_file = s:CurrentSessionFile()
    if a:force_for_exit
        call s:DropTerminalBuffers()
    elseif s:HasTerminalBuffers()
        echohl WarningMsg
        echom 'Session not saved: close terminal buffers first, or quit Vim and auto-save will skip them.'
        echohl None
        let s:last_session_save_status = 'skipped: terminal buffers open'
        return
    endif
    try
        execute 'mksession! ' . fnameescape(l:session_file)
    catch
        echohl ErrorMsg
        echom 'Session save failed: ' . v:exception
        echohl None
        let s:last_session_save_status = 'failed: ' . v:exception
        return
    endtry
    let v:this_session = l:session_file
    let s:last_session_save_status = 'saved: ' . fnamemodify(l:session_file, ':~')
    if !a:force_for_exit
        echom 'Session saved: ' . fnamemodify(s:CurrentSessionRoot(), ':~')
    endif
endfunction

function! s:RestoreCurrentSession(show_messages) abort
    if !s:SessionAvailable(a:show_messages)
        let s:last_session_restore_status = get(g:, 'corporate_safe_no_local_state', 0) ? 'disabled: no local state' : 'unavailable: session directory missing'
        return
    endif
    let l:session_file = s:CurrentSessionFile()
    call s:DropTerminalBuffers()
    if !filereadable(l:session_file)
        if a:show_messages
            echom 'No session saved for: ' . fnamemodify(s:CurrentSessionRoot(), ':~')
        endif
        let s:last_session_restore_status = 'not found: ' . fnamemodify(l:session_file, ':~')
        return
    endif
    try
        execute 'source ' . fnameescape(l:session_file)
    catch
        echohl ErrorMsg
        echom 'Session restore failed: ' . v:exception
        echohl None
        let s:last_session_restore_status = 'failed: ' . v:exception
        return
    endtry
    call s:CleanMissingBuffers()
    let v:this_session = l:session_file
    let s:last_session_restore_status = 'restored: ' . fnamemodify(l:session_file, ':~')
    if a:show_messages
        echom 'Session restored: ' . fnamemodify(s:CurrentSessionRoot(), ':~')
    endif
endfunction

function! s:DeleteCurrentSession() abort
    if !s:SessionAvailable(1)
        return
    endif
    let l:session_file = s:CurrentSessionFile()
    if delete(l:session_file) == 0
        echom 'Session deleted: ' . fnamemodify(s:CurrentSessionRoot(), ':~')
        return
    endif
    echom 'No session file to delete for: ' . fnamemodify(s:CurrentSessionRoot(), ':~')
endfunction

function! s:MaybeRestoreAutoSession() abort
    if !s:ShouldAutoSession()
        return
    endif
    let s:auto_session_root = s:SessionRootFromStartup()
    let s:startup_root = s:auto_session_root
    execute 'cd ' . fnameescape(s:auto_session_root)
    call s:RestoreCurrentSession(0)
endfunction

function! s:MaybeSaveAutoSession() abort
    if !s:ShouldAutoSession()
        return
    endif
    if empty(s:auto_session_root)
        let s:auto_session_root = s:SessionRootFromStartup()
    endif
    call s:SaveCurrentSession(1)
endfunction

augroup ProjectRoot
    autocmd!
    autocmd VimEnter * if empty(s:startup_root) | let s:startup_root = s:SessionRootFromStartup() | endif
augroup END

augroup Session
    autocmd!
    autocmd VimEnter * nested call s:MaybeRestoreAutoSession()
    autocmd VimLeavePre * call s:MaybeSaveAutoSession()
augroup END

nnoremap <leader>ss :call <SID>SaveCurrentSession(0)<CR>
nnoremap <leader>sr :call <SID>RestoreCurrentSession(1)<CR>
nnoremap <leader>sd :call <SID>DeleteCurrentSession()<CR>

" ----------------------------------------------------------
" Vimrc shortcuts
" ----------------------------------------------------------
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
