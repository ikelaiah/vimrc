" ==========================================================
" Corporate-Safe Vim Configuration
" Plugin-free stock Vim: no additional plugins or external tools
" ==========================================================

set nocompatible
if has('multi_byte')
    set encoding=utf-8
    set fileencodings=utf-8,default,latin1
endif
let g:corporate_safe_vim_version = '1.0.0'
filetype plugin indent on
syntax on

" ----------------------------------------------------------
" Leader key (must be set before any mappings)
" ----------------------------------------------------------
let mapleader=" "

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

let s:backup_dir = s:EnsureDir(s:state_root . '/backup')
let s:undo_dir = s:EnsureDir(s:state_root . '/undo')
let s:swap_dir = s:EnsureDir(s:state_root . '/swap')
let s:session_dir = s:EnsureDir(s:state_root . '/sessions')

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
if exists('&signcolumn')
    set signcolumn=yes
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

augroup FileTypeSettings
    autocmd!
    autocmd FileType javascript,css,json,yaml,toml,lua setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType markdown setlocal wrap linebreak colorcolumn=0
    autocmd FileType help setlocal colorcolumn=0 nolist
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
    set clipboard=unnamed,unnamedplus
endif

" ----------------------------------------------------------
" Backup safety
" ----------------------------------------------------------
set backup
set writebackup
set swapfile
set undofile
set diffopt+=vertical

set autoread
augroup AutoRead
    autocmd!
    autocmd FocusGained,BufEnter * checktime
augroup END

if !empty(s:backup_dir)
    let &backupdir = s:backup_dir . '//'
endif
if !empty(s:swap_dir)
    let &directory = s:swap_dir . '//'
endif
if !empty(s:undo_dir)
    let &undodir = s:undo_dir . '//'
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
        \ 'Files',
        \ '  <Space>ff    find file in project path',
        \ '  <Space>e     toggle project explorer',
        \ '  <Space>fr    open recent file',
        \ '  <Space><Space> switch to alternate file',
        \ '',
        \ 'Search',
        \ '  <Space>g     search project',
        \ '  <Space>fw    search word under cursor',
        \ '  File glob examples: **/*, **/*.py, app/**/*.js',
        \ '  ]q / [q      next / previous quickfix result',
        \ '  <Space>co    open quickfix',
        \ '  <Space>cc    close quickfix',
        \ '',
        \ 'Buffers and Windows',
        \ '  <Space>fb    choose buffer',
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
        \ '  <Space>z     toggle wrap',
        \ '',
        \ 'Sessions',
        \ '  <Space>ss    save session',
        \ '  <Space>sr    restore session',
        \ '  <Space>sd    delete session',
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

nnoremap <leader>? :call <SID>ShowHelp()<CR>

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
function! s:ProjectGrep(pattern, glob) abort
    let l:pattern = a:pattern
    if empty(l:pattern)
        echo 'Project search cancelled'
        return
    endif
    let l:glob = empty(a:glob) ? '**/*' : a:glob
    if l:glob =~# '[|[:cntrl:]]'
        echohl ErrorMsg
        echom 'Unsafe file glob. Avoid command separators and control characters.'
        echohl None
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

    copen
    wincmd p
    echom 'Project matches: ' . len(getqflist()) . ' in ' . l:glob
endfunction

function! s:PromptProjectGrep() abort
    let l:pattern = input('Project grep: ', expand('<cword>'))
    if empty(l:pattern)
        call s:ProjectGrep('', '')
        return
    endif
    let l:glob = input('File glob: ', '**/*')
    call s:ProjectGrep(l:pattern, l:glob)
endfunction

function! s:ProjectGrepWord() abort
    let l:word = expand('<cword>')
    if empty(l:word)
        echo 'No word under cursor'
        return
    endif
    let l:glob = input('File glob: ', '**/*')
    call s:ProjectGrep('\<' . escape(l:word, '\.*$^~[]') . '\>', l:glob)
endfunction

function! s:PickBuffer() abort
    ls
    let l:target = input('Buffer number/name: ')
    if empty(l:target)
        echo 'Buffer switch cancelled'
        return
    endif
    try
        execute 'buffer ' . fnameescape(l:target)
    catch
        echohl ErrorMsg
        echom v:exception
        echohl None
    endtry
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

nnoremap ]q :call <SID>QuickfixStep(1)<CR>
nnoremap [q :call <SID>QuickfixStep(-1)<CR>

nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :cclose<CR>

nnoremap <leader>fb :call <SID>PickBuffer()<CR>

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
set statusline=%f\ %m%r\ [%Y]\ %=%l:%c\ (%p%%)

" ----------------------------------------------------------
" Sessions
" ----------------------------------------------------------
" Keep buffers, window layout, tabs, and folds in per-project sessions.
set sessionoptions=buffers,curdir,folds,tabpages,winsize,winpos

let s:auto_session_root = ''
let s:startup_root = ''

" Auto-restore session when Vim starts with no file args, or with only a directory arg.
" Auto-save session on exit in those same cases.
function! s:ShouldAutoSession() abort
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
        return
    endif
    let l:session_file = s:CurrentSessionFile()
    if a:force_for_exit
        call s:DropTerminalBuffers()
    elseif s:HasTerminalBuffers()
        echohl WarningMsg
        echom 'Session not saved: close terminal buffers first, or quit Vim and auto-save will skip them.'
        echohl None
        return
    endif
    try
        execute 'mksession! ' . fnameescape(l:session_file)
    catch
        echohl ErrorMsg
        echom 'Session save failed: ' . v:exception
        echohl None
        return
    endtry
    let v:this_session = l:session_file
    if !a:force_for_exit
        echom 'Session saved: ' . fnamemodify(s:CurrentSessionRoot(), ':~')
    endif
endfunction

function! s:RestoreCurrentSession(show_messages) abort
    if !s:SessionAvailable(a:show_messages)
        return
    endif
    let l:session_file = s:CurrentSessionFile()
    call s:DropTerminalBuffers()
    if !filereadable(l:session_file)
        if a:show_messages
            echom 'No session saved for: ' . fnamemodify(s:CurrentSessionRoot(), ':~')
        endif
        return
    endif
    try
        execute 'source ' . fnameescape(l:session_file)
    catch
        echohl ErrorMsg
        echom 'Session restore failed: ' . v:exception
        echohl None
        return
    endtry
    call s:CleanMissingBuffers()
    let v:this_session = l:session_file
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
