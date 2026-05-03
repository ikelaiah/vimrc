# Corporate-Safe Vim Configuration

<p align="center">
<img src="assets/banner.svg" alt="Corporate Safe Vim">
</p>

![Vim 8+](https://img.shields.io/badge/Vim-8%2B-brightgreen)
![Version](https://img.shields.io/badge/version-1.1.0-informational)
[![Vimrc Smoke Test](https://github.com/ikelaiah/vimrc/actions/workflows/vimrc-smoke.yml/badge.svg)](https://github.com/ikelaiah/vimrc/actions/workflows/vimrc-smoke.yml)
![Made with Vim](https://img.shields.io/badge/Made%20with-Vim-019733)
![Plugins](https://img.shields.io/badge/plugins-none-blue)
![Dependencies](https://img.shields.io/badge/dependencies-none-success)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

**Plugin-Free Vim for Locked-Down Workstations**

A **pure Vim configuration designed for restricted corporate environments**.

No additional Vim plugins. No plugin manager. No Python / Node / ripgrep / ctags required. No external binaries required for startup, editing, search, or sessions.

Optional Git workflow mappings call your installed `git` executable only when you invoke them.

Just **stock Vim features used effectively**.

Current release: **1.1.0**. See [CHANGELOG.md](CHANGELOG.md).

---

## Start Here

1. Install stock Vim or use the Vim already available on your workstation.
2. Put this repository's `.vimrc` at the normal Vim config path for your OS.
3. Open Vim and run `:CorporateSafeHealth` to confirm the runtime directories, mappings, and policy-related settings.

For quick install commands, see [Quick Install](#quick-install).

---

## Who This Is For

This configuration is for developers who need a practical Vim setup on machines where editor plugins, package managers, language runtimes, and helper binaries are restricted or require approval.

It is also useful when you want a portable fallback editor that keeps common developer workflows available with stock Vim features only.

---

## What This Is Not

This is not a plugin distribution, a plugin manager setup, an IDE replacement, or a formal security baseline.

It does not claim company approval or certification. It documents its local file footprint so you can compare it with your own workplace requirements.

---

## What Corporate-Safe Means Here

In this repository, **corporate-safe** means a deliberately small approval footprint:

- no Vim plugins
- no plugin manager
- no package-managed dependencies
- no Python, Node, ripgrep, ctags, or other external helper tools required for startup, editing, search, or sessions
- stock Vim features only

The Git workflow commands are optional wrappers around an installed `git` executable. They do not run at startup and are unavailable gracefully when `git` is not on `PATH`.

It does **not** claim formal security certification, company policy approval, or a zero local data footprint. Vim can still create local recovery and history files; those files are documented below.

---

## Features

- [x] Plugin-free
- [x] Self-contained `.vimrc`
- [x] Works on stock Vim (Git Bash, Linux, macOS, Windows)
- [x] Truecolor support
- [x] Gruvbox fallback to Desert
- [x] Early UTF-8 encoding setup for portable whitespace markers
- [x] Sidebar file explorer that toggles cleanly from any buffer
- [x] Prompted project search using `vimgrep` with file-glob scoping
- [x] Configurable deep file search and default project-search glob
- [x] Search word under cursor across the project
- [x] Optional stock-Vim Git workflow mappings for status, changed files, diff, log, blame, staging, commit, push, pull, and restore
- [x] Git changed-files quickfix list for jumping through work-in-progress files
- [x] In-editor shortcut cheatsheet
- [x] In-editor health report for locked-down workstation debugging
- [x] Recent-file picker
- [x] Toggleable whitespace visibility (tabs, trailing spaces, nbsp)
- [x] Toggleable relative line numbers, off by default
- [x] File-local working directory shortcut
- [x] Guarded system clipboard yank/paste mappings
- [x] Brief yank highlighting using built-in Vim match/timer support
- [x] No automatic comment continuation when opening a new line with `o`
- [x] Language-aware indentation (consistent tabstop/shiftwidth/softtabstop per filetype)
- [x] Count-aware `j`/`k` motion (works with `5j`, `10k`, etc.)
- [x] Hidden buffers for easier switching between unsaved files
- [x] Smarter built-in completion and command-line matching
- [x] Centralized backup, undo, swap, and session files when Vim can create the runtime directories
- [x] Minimal local-state mode for sensitive folders
- [x] Auto-reload files changed outside Vim
- [x] Per-project auto-save and restore sessions (terminal buffers excluded)
- [x] Auto-session opt-out through `g:corporate_safe_auto_sessions`
- [x] Guarded session save/restore errors so failed session writes are not reported as success
- [x] Safer truecolor probing for terminals that expose the option but cannot enable it
- [x] Safer prompted project search that rejects command separators in file globs
- [x] Quickfix next/previous mappings with readable boundary errors
- [x] CI smoke tests for sourcing, relative-number toggle, netrw toggle, sessions, health output, and policy opt-outs

Vim's built-in filetype detection handles many languages. This configuration only adds a small set of indentation defaults where they improve day-to-day editing.

## Screenshot

Example editing experience using this configuration.

![Screenshot of Vim with this configuration](assets/screenshot.png)

Editing Python with:

- absolute line numbers, with relative line numbers available on demand
- cursor line highlight
- toggleable whitespace markers
- color column at 100
- Gruvbox theme

---

## Installation

### Linux / macOS

Save the `.vimrc` as:

```text
~/.vimrc
```

### Git Bash on Windows

Save the `.vimrc` as:

```text
~/.vimrc
```

Git Bash Vim behaves like a Unix Vim build, so it uses `~/.vimrc` and stores runtime files under `~/.vim/`.

### Native Windows Vim

Save the `.vimrc` as:

```text
%USERPROFILE%\_vimrc
```

On Windows, Vim also creates its runtime directories under `~/vimfiles/` (backup, undo, swap, per-project sessions) automatically.

Restart Vim after installing.

---

## Policy Footprint and Recovery

This configuration does not require plugins or external tools, but Vim still creates local recovery and history files. They are kept in central folders instead of being scattered through project directories.

| File type | Git Bash / Linux / macOS | Native Windows Vim | Purpose |
| --------- | ------------------------ | ------------------ | ------- |
| Backups   | `~/.vim/backup/` | `~/vimfiles/backup/` | Last saved file copies |
| Undo      | `~/.vim/undo/` | `~/vimfiles/undo/` | Persistent undo history |
| Swap      | `~/.vim/swap/` | `~/vimfiles/swap/` | Crash recovery for unsaved edits |
| Sessions  | `~/.vim/sessions/` | `~/vimfiles/sessions/` | Per-project window and buffer layout |
| Viminfo / oldfiles | Vim default under `$HOME` | Vim default under `%USERPROFILE%` | Command history, marks, registers, recent files |

These files can contain source text. Treat those directories as part of your normal development footprint and clear them according to your company's retention rules.

If Vim cannot create one of these directories, startup continues and Vim falls back to its default behavior for the affected feature. Sessions are disabled until the session directory is available.

### Minimal Local-State Mode

For sensitive folders, enable this before the runtime directory section runs:

```vim
let g:corporate_safe_no_local_state = 1
```

This disables Vim-managed backup, write-backup, swap, persistent undo, sessions, and viminfo/shada writes from this configuration. It also prevents this vimrc from creating `~/.vim/` or `~/vimfiles/` runtime directories.

This mode does not stop files you explicitly write with `:write`, and it cannot control operating-system, terminal, shell, or external editor logging.

---

## Quick Install

### Git Bash / Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/ikelaiah/vimrc/main/.vimrc -o ~/.vimrc
```

### Native Windows Vim (PowerShell)

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/ikelaiah/vimrc/main/.vimrc -OutFile $HOME\_vimrc
```

---

## Theme Behavior

The configuration prefers **Gruvbox** if available.

```vim
colorscheme gruvbox
```

If Gruvbox is unavailable, Vim falls back to:

```vim
colorscheme desert
```

---

## Sidebar File Explorer

Toggle the sidebar file explorer:

```text
Space e
```

This uses Vim's built-in **netrw** in sidebar mode (`Lexplore`). Press `Space e` again from any buffer to close the existing sidebar.

Features:

- left sidebar
- tree view
- quick file navigation
- opens at the original project directory from `vim .`
- no plugins required

---

## Navigation

Leader key: `Space`

Open the in-editor shortcut cheatsheet:

```text
Space ?
```

---

### Files

| Action           | Shortcut      |
| ---------------- | ------------- |
| Open file        | `Space ff`    |
| Open recent file | `Space fr`    |
| Sidebar explorer | `Space e`     |
| Switch last file | `Space Space` |
| Local cwd to current file directory | `Space cd` |

---

### Project Search

| Action                   | Shortcut   |
| ------------------------ | ---------- |
| Search project           | `Space g`  |
| Search word under cursor | `Space fw` |
| Next result              | `]q`       |
| Previous result          | `[q`       |
| Open results             | `Space co` |
| Close results            | `Space cc` |

Example:

```vim
:vimgrep /TODO/ **/*.py
```

`Space g` prompts for a search term and file glob, runs `vimgrep`, and opens the quickfix list automatically. Use `**/*` for everything, `**/*.py` for Python, or a narrower glob such as `app/**/*.js`.

`Space fw` searches the word under the cursor and also prompts for the file glob.

The default file glob is configurable:

```vim
let g:corporate_safe_search_glob = 'src/**/*'
```

Deep `:find` support is enabled by default through `set path+=**`. Disable it for very large repositories:

```vim
let g:corporate_safe_deep_find = 0
```

---

### Optional Git Workflow

Git support is plugin-free and optional. Vim starts normally without `git`; the mappings below shell out to the installed `git` executable only when invoked.

| Action | Shortcut / command |
| ------ | ------------------ |
| Status | `Space Gs` or `:Git` |
| Changed files in quickfix | `Space Gq` |
| Diff current file | `Space Gd` |
| Recent repository log | `Space Gl` |
| Blame current file | `Space Gb` |
| Stage current file | `Space Ga` |
| Stage all changes | `Space GA` |
| Commit staged changes with a message prompt | `Space Gc` |
| Push | `Space Gp` |
| Pull fast-forward only | `Space GP` |
| Restore current file from `HEAD` with confirmation | `Space Gr` |
| Run a git command from the repo root | `Space Gg` or `:Git {args}` |

Examples:

```vim
:Git status --short --branch
:Git diff -- README.md
:Git log --oneline --decorate -10
```

Git status, diff, log, blame, stage, commit, and restore output opens in a read-only scratch buffer. Press `q` in that buffer to close it. `Space Gq` loads changed files into the quickfix list so `]q` and `[q` can jump through your current work.

For ad hoc `:Git {args}` commands, shell pipes, redirects, command substitution, and command separators are rejected; use a normal shell for those.

The `Space Gp` and `Space GP` mappings use Vim's normal shell command path so credential prompts and remote output behave like standard `:!git push` / `:!git pull --ff-only` commands.

---

### Buffers

| Action          | Shortcut   |
| --------------- | ---------- |
| Next buffer     | `Space bn` |
| Previous buffer | `Space bp` |
| Close buffer    | `Space bd` |

Use Vim's built-in `:ls` and `:b {number-or-name}` for direct buffer selection.

---

### Windows

| Action                  | Shortcut       |
| ----------------------- | -------------- |
| Move left               | `Ctrl h`       |
| Move down               | `Ctrl j`       |
| Move up                 | `Ctrl k`       |
| Move right              | `Ctrl l`       |
| Cycle to next window    | `Ctrl w w`     |
| Split horizontally      | `Space -`      |
| Split vertically        | `Space \`      |
| Equalise all windows    | `Space =`      |
| Close current split     | `Space c`      |
| Keep only current split | `Space o`      |

Resize windows:

```text
Space ← → ↑ ↓
```

---

### Save / Quit

| Action                        | Shortcut  |
| ----------------------------- | --------- |
| Save                          | `Space w` |
| Quit (prompts if unsaved)     | `Space q` |
| Save & quit                   | `Space x` |
| Force quit (discard changes)  | `Space Q` |

---

## Sessions

Sessions save and restore your open buffers, window layout, tabs, and folds on a per-project basis. Each working directory gets its own session file, so `vim .` inside different folders restores different layouts.

| Action          | Shortcut   |
| --------------- | ---------- |
| Save session    | `Space ss` |
| Restore session | `Space sr` |
| Delete session  | `Space sd` |

**Auto-save / auto-restore:** When Vim is opened with no file arguments, or with a single directory argument such as `vim .`, Vim restores the session for that directory on startup and saves back to that same directory-specific session on exit.

Auto sessions are enabled by default to keep folder opens feeling like VS Code. To opt out, set this near the top of `.vimrc`:

```vim
let g:corporate_safe_auto_sessions = 0
```

Auto sessions are also disabled when `g:corporate_safe_no_local_state = 1`.

**Terminal safety:** Auto-save wipes terminal buffers before the session file is written, so a broken `:terminal` can never poison the saved project session. Manual `Space ss` refuses to save while terminal buffers are open; quit Vim normally instead and the auto-save path will strip them safely.

**Safe restore:** The following buffer types are automatically discarded on restore:

- Terminal buffers (`term://`) — stuck terminals can never block startup
- netrw explorer buffers — avoids broken internal tree state errors
- Quickfix / location list windows
- Scratch buffers (help, man pages, previews)
- Files that no longer exist on disk

---

## Exiting Vim

The recommended ways to exit, from most to least cautious:

| Situation                     | Command    | What it does                         |
| ----------------------------- | ---------- | ------------------------------------ |
| Save and quit current window  | `Space x`  | Writes only if changed, then quits   |
| Save and quit current window  | `:x`       | Same as above (built-in command)     |
| Save and quit                 | `:wq`      | Always writes, then quits            |
| Quit with prompt if unsaved   | `Space q`  | Prompts Save/Discard/Cancel          |
| Quit (no unsaved changes)     | `:q`       | Quits if buffer is clean             |
| Force quit, discard changes   | `Space Q`  | Discards all changes, no prompt      |
| Force quit                    | `:q!`      | Discards unsaved changes, then quits |
| Quit all windows              | `:qa`      | Quits all windows (fails if unsaved) |
| Quit all, discard all changes | `:qa!`     | Force-quits everything               |
| Save all and quit all         | `:wqa`     | Saves all buffers, quits all windows |

> **Tip:** If you are stuck in insert mode, press `Esc` first, then use any of the above.
>
> **Tip:** If you opened a terminal inside Vim (`:terminal`) and it is unresponsive, close it with `:bwipeout!` or quit all with `:qa!`.

---

## Editing Quality of Life

Open shortcut help:

```text
Space ?
```

Clear search highlight:

```text
Space /
```

Toggle wrap:

```text
Space z
```

Toggle relative line numbers:

```text
Space rn
```

Whitespace markers are off by default. Toggle them when you need to inspect tabs, trailing spaces, or non-breaking spaces:

```text
Space l
```

Trailing whitespace markers are visible when whitespace markers are enabled, but whitespace is not automatically removed on save.

Yanked text is briefly highlighted when the running Vim supports `TextYankPost`, `matchaddpos()`, and timers.

When Vim has clipboard support, `Space y` yanks to the system clipboard and `Space p` pastes from it.

Opening a new line with `o` does not automatically continue comment leaders.

---

## Diagnostics

Open a stock-Vim health report:

```vim
:CorporateSafeHealth
```

The report shows the config version, Vim version, plugin/external-tool requirements, optional Git availability, feature support, runtime directory status, local-state mode, project/session paths, netrw availability, auto-session state, session save/restore status, deep-find settings, default search glob, and key mappings.

---

## Philosophy

This configuration focuses on three principles:

### Reliability

Works everywhere Vim runs.

### Low Approval Footprint

Usable in environments that forbid editor plugins, package managers, or external helper tools.

### Speed

Navigation should be faster than thinking.

---

## CI Smoke Test

The GitHub Actions workflow runs `.vimrc` with Vim in Ex mode and isolated `HOME` directories. It catches syntax errors, runtime directory regressions, line-ending regressions, relative-number toggle regressions, netrw sidebar toggle regressions, session save/restore regressions, optional Git-command regressions, health-report regressions, and opt-out regressions without installing runtime plugins.

---

## Why This Exists

Many corporate environments restrict developers from installing or approving:

- editor plugins
- package-managed dependencies
- external binaries
- scripting runtimes

This repository demonstrates that Vim can still provide a productive
editing experience using only built-in functionality.

---

## License

MIT License
