# Changelog

All notable changes to this project are documented here.

## [1.0.0] - 2026-04-29

### Added

- Declared `g:corporate_safe_vim_version` as `1.0.0` and surfaced it in the built-in help buffer.
- Added defensive runtime directory creation for backup, undo, swap, and session storage.
- Added yank highlighting through built-in Vim match/timer APIs when available.
- Added safer quickfix navigation wrappers for `]q` and `[q`.
- Added README badges for version and the GitHub Actions smoke test.

### Changed

- Truecolor is now enabled with a guarded `silent! set termguicolors` path so non-truecolor environments continue startup.
- Encoding is set to UTF-8 early so list characters load correctly in Git Bash Vim.
- The `Space e` file explorer mapping now silently toggles an existing netrw sidebar from any buffer.
- Session save and restore now report real failures instead of silently claiming success.
- Project grep now rejects file globs containing command separators or control characters.
- README now documents the versioned baseline, runtime directory fallback behavior, and the new editing safeguards.

### Removed

- Removed `set lazyredraw`; modern Vim redraw behavior is more reliable without it.
- Removed the legacy `F2` paste-mode toggle.
