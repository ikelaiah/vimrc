# ⚙️ ikelaiah-vimrc — Minimal, Plugin-Free Vim Configuration

**Purpose**  
A structured, stable, plugin-manager-free Vim configuration for professional development work.

The core config is plugin-free (no external plugins/plugin managers). It does use Vim's built-in filetype detection/plugins/indent support, plus an optional external colorscheme (`gruvbox`) and optional CLI tools for linting/formatting.

**Filetypes with custom settings**
- Python
- JavaScript
- PHP
- SQL
- Markdown
- HTML
- CSS
- JSON
- YAML


**Philosophy**  
Minimal. Stable. Deterministic. Corporate-safe.  
No plugin managers. No LSP frameworks. No visual clutter.



## Architecture Overview

The configuration is deliberately structured into nine logical sections:

1. Foundation        – Core Vim behavior
2. Editing           – Indentation, text manipulation
3. User Interface    – Visual presentation
4. Search            – Finding text efficiently
5. Clipboard & Undo  – Persistent history and OS integration
6. File Navigation   – Splits, file search, workflow
7. Session Support   – Project memory
8. File Type Settings – Per-language overrides
9. Enhancements      – Clean quality-of-life improvements

This order is intentional. Foundation must load first.



## Installation

### Linux / macOS

1. Copy `.vimrc` to:

    `~/.vimrc`

2. Create persistent undo directory:

    `mkdir -p ~/.vim/undodir`

### Windows (PowerShell)

1. Copy the repo's `.vimrc` contents to your Vim config file (commonly):

    `$HOME\_vimrc`

2. Create the undo directory used by this config (`~/.vim/undodir`):

    `New-Item -ItemType Directory -Force $HOME\.vim\undodir`

### Optional CLI Tools (for linting / formatting / run shortcuts)

If you skip these tools, Vim still works normally. Only the related file-type lint/format/run commands will be unavailable.

Python (for `\l` / `\r` in Python files):
`pip install flake8`

JavaScript (for `\l`, `\r`, `\f` in JavaScript files):
`npm install -g eslint prettier`

PHP (for `\l` / `\r` in PHP files):
Uses built-in `php -l`

SQL (for `:make` in SQL files):
Requires `psql` (or adjust `makeprg` for your database)

Notes:

- `\r` run shortcuts also require the language runtime (`python3` for Python, `node` for JavaScript, `php` for PHP).
- JavaScript lint/format commands use `npx` in this config, so project-local installs also work.
- Markdown formatting uses `prettier` directly, so it expects a global `prettier` command unless you change that mapping.


## Theme Behavior

Preferred theme (optional):
`gruvbox`

Fallback theme:
`desert`

Theme logic:

- `gruvbox` is optional.
- If `gruvbox` is installed, it loads automatically.
- If not available, Vim falls back to `desert`.
- Truecolor (`termguicolors`) is enabled only if supported.

Dark background is assumed.



## Beginner Notes (Important)

- `Leader` key in this config is `\` (backslash).
- So `\l` means: press backslash, then `l`.
- `:make` runs the configured tool for the current file type (for example `flake8` for Python).
- Lint/build results open in Vim's Quickfix window automatically when there are messages.



## Core Behavior

- UTF-8 encoding
- Absolute line numbers only
- Filetype-based indentation (via `filetype plugin indent on`)
- Split windows open below/right
- Custom minimal statusline
- Live preview for `:substitute` (if supported)
- Confirm prompt on quit with unsaved changes (instead of error)
- Swap files disabled (persistent undo handles recovery)
- Scroll context: 8 lines always visible above/below cursor



## Search

- Case-insensitive by default
- Smart case if uppercase used
- Incremental search
- Highlight all matches
- Clear highlight with `Esc Esc` (Normal mode)


## Clipboard & Undo

- Uses system clipboard if available
- Persistent undo across restarts
- Undo levels: 10,000
- Undo files stored in `~/.vim/undodir`



## File Navigation

- Recursive file search with `:find filename`
- Command completion via `wildmenu`
- Ignored in `:find` and wildmenu: `node_modules/`, `.git/`, `__pycache__/`, compiled files
- Split navigation using `Ctrl+h / Ctrl+j / Ctrl+k / Ctrl+l`
- Toggle invisible characters (off by default): `\w`
- Run linter (`:make`): `\l`
- Run current file: `\r`
- Format JS/Markdown (where configured): `\f`
- Git diff current file: `\gd`
- List buffers: `\b`
- Next buffer: `\n`
- Previous buffer: `\p`
- Quick save: `Ctrl+s` (Normal and Insert mode)
- Move line down: `Alt+j`
- Move line up: `Alt+k`
- Indent in Visual mode without losing selection: `<` / `>`
- Next quickfix error: `]q`
- Previous quickfix error: `[q`



## Session Support

Each project may contain:

`.vimsession`

On startup:

- If `.vimsession` exists and Vim was started with no file arguments, it loads automatically.

On exit:

- Session is saved automatically only when Vim was started with no file arguments (matches the current `.vimrc` behavior).

Sessions intentionally do not save:

- Global options
- Local options
- Global variables

This prevents UI corruption across projects.

Cursor position is restored when reopening files.


## File Type Settings

Python:

- 4-space indentation
- `flake8` linting (`:make` / `\l`)
- `\r` executes with `python3`

JavaScript:

- 2-space indentation
- ESLint linting (`:make` / `\l`)
- `\r` executes with `node`
- `\f` formats with Prettier (if installed / available)

PHP:

- 4-space indentation
- `php -l` syntax check (`:make` / `\l`)
- `\r` executes with `php`

SQL:

- 4-space indentation
- Uses `psql` via `:make`

Markdown:

- Line wrapping enabled
- Spell checking enabled
- 80 character text width
- `\f` formats with Prettier (if installed / available)

HTML:

- 2-space indentation

CSS:

- 2-space indentation

JSON:

- 2-space indentation
- `\f` formats with Prettier (if installed / available)

YAML:

- 2-space indentation


## Enhancements

Trailing whitespace:

- Highlighted in red
- Automatically stripped on save (except Markdown, where trailing spaces are meaningful)

File auto-reload:

- Detects external changes (for example `git pull`)

Improved diff:

- Vertical layout
- Histogram algorithm
- Indent heuristic

Rendering optimizations:

- `lazyredraw` enabled (may cause visual artifacts in some terminals; disable if you see redraw glitches)

Command history:

- 1000 entries

Quickfix auto-close:

- Quickfix window closes automatically when it is the last window open

Ctrl+s note:

- Some terminals intercept `Ctrl+s` (XOFF flow control). Add `stty -ixon` to your shell profile (`.bashrc` / `.zshrc`) to disable this.


## Design Principles

This configuration avoids:

- Plugin managers
- LSP frameworks
- Floating diagnostics
- Popup UIs
- Heavy key remapping

It relies on:

- Vim-native features
- CLI tooling
- Quickfix window
- Structured augroups

The goal:

- Predictable behavior.  
- Low maintenance.  
- High signal, low noise.


## Troubleshooting

Check loaded scripts:
`:scriptnames`

Check current theme:
`:echo g:colors_name`

If sessions behave strangely:

- Delete `.vimsession`

If syntax highlighting disappears:

- Confirm `syntax on`
- Remove stale session file


## Final Note

This is not a hobby configuration.  
It is a disciplined workstation environment.

Stability over novelty.  
Clarity over cleverness.  
Focus over flash.

Tools should disappear.  
Work should remain.
