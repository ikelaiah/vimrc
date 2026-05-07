# Changelog

All notable changes to this project are documented here.

## [Unreleased]

### Added

- Added `Space qq` to toggle the quickfix window without changing the current result list.
- Added `Space bb` as a lightweight buffer jump helper using Vim's built-in `:ls` and `:b`.
- Added README quickfix workflow guidance so project search, legacy navigation, TODO scans, hotspot scans, and Git changed files share one navigation model.

### Changed

- Clarified quickfix titles for project search, legacy outlines, TODO markers, and Git changed files.
- Updated in-editor help and health mapping output for the new quickfix and buffer shortcuts.

## [1.4.0] - 2026-05-05

### Added

- Added explicit file-trust defaults that disable project-controlled modelines and local vimrc/exrc loading.
- Added manual trailing-whitespace cleanup with `Space tw` / `:CorporateSafeTrimWhitespace`.
- Added quickfix auto-open and quickfix history mappings with `Space cw`, `Space cn`, and `Space cp`.
- Added large-file mode with configurable `g:corporate_safe_large_file_bytes`.
- Added staged Git diff and unstage actions with `Space GD`, `Space Gu`, `Space GU`, and focused `:CorporateSafeGit...` commands.
- Expanded stock filetype indentation defaults for TypeScript, JSX/TSX, HTML/XML, CSS preprocessors, Vue/Svelte, and Go.

### Changed

- System clipboard integration is no longer enabled globally by default; explicit `Space y` / `Space p` mappings remain available when Vim has clipboard support, with opt-in automatic clipboard through `g:corporate_safe_auto_clipboard`.
- `Space GA` now confirms before staging all Git changes.

### Removed

- Removed the `Space Q` force-quit mapping; use Vim's built-in `:q!` when discarding changes is intentional.

## [1.3.0] - 2026-05-04

### Added

- Added outgoing-call quickfix navigation for the current function with `Space fO` / `:CorporateSafeOutgoing`.
- Added a legacy symbol inspection report with `Space fI` / `:CorporateSafeInspect`.
- Added TODO marker and legacy hotspot quickfix scans with `Space fT`, `Space fh`, `:CorporateSafeTodos`, and `:CorporateSafeHotspots`.
- Expanded legacy outline and definition heuristics for Perl, PowerShell, T-SQL, COBOL, and ABAP-style files.
- Added `:CorporateSafeTagsHealth` / `Space fH` for tags-file discovery diagnostics.
- Added a README tutorial for inspecting legacy code and triaging issues without AI tooling.

## [1.2.0] - 2026-05-04

### Added

- Added plugin-free legacy-code navigation helpers for current-file outlines, likely definitions, references/callers, and combined symbol flow using quickfix and `vimgrep`.
- Added optional Vim tags-file jump support through `Space ft` / `:CorporateSafeTag` with upward `tags` file discovery.
- Added `g:corporate_safe_legacy_glob` to scope legacy symbol searches separately from normal project grep.
- Documented the new legacy navigation workflow and surfaced the mappings in help and health output.

## [1.1.0] - 2026-05-04

### Added

- Added optional stock-Vim Git workflow commands and `Space G...` mappings for status, changed-file quickfix, current-file diff, log, blame, staging, commit, push, pull, and restore.
- Added `:Git`, `:CorporateSafeGit`, and focused `:CorporateSafeGit...` commands for plugin-free Git use from the repository root.
- Added Git availability and repository detection to `:CorporateSafeHealth`.
- Documented the optional Git workflow and clarified that Git is only called when those mappings or commands are invoked.
- Guarded ad hoc `:Git {args}` commands against shell separators, redirects, and command substitution.

## [1.0.0] - 2026-04-29

### Added

- Declared `g:corporate_safe_vim_version` as `1.0.0` and surfaced it in the built-in help buffer.
- Added defensive runtime directory creation for backup, undo, swap, and session storage.
- Added yank highlighting through built-in Vim match/timer APIs when available.
- Added safer quickfix navigation wrappers for `]q` and `[q`.
- Added CI smoke coverage for relative-number toggling, netrw sidebar toggling, and session save/restore.
- Added `:CorporateSafeHealth` for stock-Vim diagnostics on locked-down workstations.
- Added `Space cd` to change the local working directory to the current file's directory.
- Added guarded `Space y` and `Space p` system clipboard mappings when Vim has clipboard support.
- Added `g:corporate_safe_no_local_state` for sensitive folders that should avoid Vim-managed backup, swap, undo, session, and viminfo/shada writes.
- Added README badges for version and the GitHub Actions smoke test.

### Changed

- Truecolor is now enabled with a guarded `silent! set termguicolors` path so non-truecolor environments continue startup.
- Theme fallback now guards both `gruvbox` and `desert` so stripped-down Vim runtimes keep starting.
- Encoding is set to UTF-8 early so list characters load correctly in Git Bash Vim.
- The `Space e` file explorer mapping now silently toggles an existing netrw sidebar from any buffer.
- Relative line numbers are now off by default and toggle with `Space rn`.
- Auto sessions remain enabled by default and can be disabled with `g:corporate_safe_auto_sessions = 0`.
- Deep `:find` support can be disabled with `g:corporate_safe_deep_find = 0`.
- Project search now uses configurable `g:corporate_safe_search_glob` as the default file glob.
- Health output now includes all configured mappings, clearer session status, local-state status, and search settings.
- Comment continuation from normal-mode `o` is disabled through `formatoptions-=o`.
- Session save and restore now report real failures instead of silently claiming success.
- Project grep now rejects file globs containing command separators or control characters.
- README now documents the versioned baseline, policy footprint, runtime directory fallback behavior, and editing safeguards.

### Removed

- Removed `set lazyredraw`; modern Vim redraw behavior is more reliable without it.
- Removed the legacy `F2` paste-mode toggle.
- Removed the custom `Space fb` buffer picker; use Vim's built-in `:ls` and `:b` instead.
