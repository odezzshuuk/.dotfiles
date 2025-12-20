## AGENTS.md

This document provides instructions for agentic coding agents operating in this repository.

### Code Style

- **Language:** Lua
- **Formatting:** `stylua` is used for formatting. Adhere to the configuration in `stylua.toml`.
- **Imports:** Use `require` for imports.
- **Naming Conventions:** Follow standard Lua naming conventions (e.g., `camelCase` for variables and functions).
- **Error Handling:** Use `pcall` and `xpcall` for error handling.
- **Types:** Use annotations for types when possible to improve clarity.

### Commands

- **Lint:** `stylua .`
- **Test:** Not applicable for this project.
- **Build:** Not applicable for this project.

### Tooling

- **Plugin Manager:** `lazy.nvim`
- **LSP:** `nvim-lspconfig` with various language servers.
- **Completion:** `nvim-cmp`
- **Fuzzy Finder:** `telescope.nvim`
