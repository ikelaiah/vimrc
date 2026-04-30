# Corporate-Safe Vim Configuration

<p align="center">
<img src="assets/banner.svg" alt="Corporate Safe Vim">
</p>

![Vim 8+](https://img.shields.io/badge/Vim-8%2B-brightgreen)
![Version](https://img.shields.io/badge/version-1.0.0-informational)
[![Vimrc Smoke Test](https://github.com/ikelaiah/vimrc/actions/workflows/vimrc-smoke.yml/badge.svg)](https://github.com/ikelaiah/vimrc/actions/workflows/vimrc-smoke.yml)
![Made with Vim](https://img.shields.io/badge/Made%20with-Vim-019733)
![Plugins](https://img.shields.io/badge/plugins-none-blue)
![Dependencies](https://img.shields.io/badge/dependencies-none-success)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

**Plugin-Free Vim for Locked-Down Workstations**

A **pure Vim configuration designed for restricted corporate environments**.

No additional Vim plugins. No package managers. No Python / Node / ripgrep / ctags calls. No external binaries required.

Just **stock Vim features used effectively**.

Current release: **1.0.0**. See [CHANGELOG.md](CHANGELOG.md).

---

## What Corporate-Safe Means Here

In this repository, **corporate-safe** means the configuration is designed to run on stock Vim without extra Vim plugins or command-line dependencies that usually need approval on locked-down workstations.

It does **not** claim formal security certification, company policy approval, or a zero local data footprint. Vim still creates local backup, undo, swap, and session files for recovery and workflow continuity; those files are documented below.

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
- [x] Search word under cursor across the project
- [x] In-editor shortcut cheatsheet
- [x] In-editor health report for locked-down workstation debugging
- [x] Recent-file picker
- [x] Toggleable whitespace visibility (tabs, trailing spaces, nbsp)
- [x] Toggleable relative line numbers, off by default
- [x] Brief yank highlighting using built-in Vim match/timer support
- [x] Language-aware indentation (consistent tabstop/shiftwidth/softtabstop per filetype)
- [x] Count-aware `j`/`k` motion (works with `5j`, `10k`, etc.)
- [x] Hidden buffers for easier switching between unsaved files
- [x] Smarter built-in completion and command-line matching
- [x] Centralized backup, undo, swap, and session files when Vim can create the runtime directories
- [x] Auto-reload files changed outside Vim
- [x] Per-project auto-save and restore sessions (terminal buffers excluded)
- [x] Auto-session opt-out through `g:corporate_safe_auto_sessions`
- [x] Guarded session save/restore errors so failed session writes are not reported as success
- [x] Safer truecolor probing for terminals that expose the option but cannot enable it
- [x] Safer prompted project search that rejects command separators in file globs
- [x] Quickfix next/previous mappings with readable boundary errors
- [x] CI smoke tests for sourcing, relative-number toggle, netrw toggle, sessions, and health output

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

## Runtime Files and Recovery

This configuration does not require plugins or external tools, but Vim still creates local recovery and history files. They are kept in central folders instead of being scattered through project directories.

| File type | Git Bash / Linux / macOS | Native Windows Vim | Purpose |
| --------- | ------------------------ | ------------------ | ------- |
| Backups   | `~/.vim/backup/` | `~/vimfiles/backup/` | Last saved file copies |
| Undo      | `~/.vim/undo/` | `~/vimfiles/undo/` | Persistent undo history |
| Swap      | `~/.vim/swap/` | `~/vimfiles/swap/` | Crash recovery for unsaved edits |
| Sessions  | `~/.vim/sessions/` | `~/vimfiles/sessions/` | Per-project window and buffer layout |

These files can contain source text. Treat those directories as part of your normal development footprint and clear them according to your company's retention rules.

If Vim cannot create one of these directories, startup continues and Vim falls back to its default behavior for the affected feature. Sessions are disabled until the session directory is available.

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

---

## Diagnostics

Open a stock-Vim health report:

```vim
:CorporateSafeHealth
```

The report shows the config version, Vim version, plugin/external-tool requirements, feature support, runtime directory status, project/session paths, netrw availability, auto-session state, and key mappings.

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

The GitHub Actions workflow runs `.vimrc` with Vim in Ex mode and isolated `HOME` directories. It catches syntax errors, runtime directory regressions, line-ending regressions, relative-number toggle regressions, netrw sidebar toggle regressions, session save/restore regressions, and health-report regressions without installing runtime plugins.

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
