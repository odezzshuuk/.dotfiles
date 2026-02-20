---
name: tauri-app-development
description: This skill should be used when working on Tauri v2 desktop applications that combine a Rust backend with a web-based frontend (React/TypeScript). It covers architecture patterns, command/event communication, state management, plugin usage, frontend-backend bindings, and platform-specific considerations.
---

# Tauri App Development

This skill provides guidance for developing cross-platform desktop applications using the Tauri v2 framework with a Rust backend and React/TypeScript frontend.

## When to Use

- Building or modifying Tauri v2 desktop applications
- Adding new Tauri commands or events
- Creating managers for backend business logic
- Setting up frontend-backend communication
- Working with Tauri plugins (store, clipboard, OS, filesystem, etc.)
- Configuring capabilities and permissions
- Managing application settings with reactive updates
- Building system tray integrations
- Handling platform-specific features (macOS, Windows, Linux)
- Auto-generating TypeScript bindings from Rust types

## Project Structure

A standard Tauri v2 app has two main directories:

```
project-root/
├── src/                    # Frontend (React/TypeScript)
│   ├── App.tsx             # Main application component
│   ├── bindings.ts         # Auto-generated TS bindings (tauri-specta)
│   ├── components/         # UI components
│   ├── hooks/              # React hooks
│   ├── stores/             # Zustand state stores
│   └── lib/                # Shared utilities and constants
├── src-tauri/              # Backend (Rust)
│   ├── Cargo.toml          # Rust dependencies
│   ├── tauri.conf.json     # Tauri configuration
│   ├── capabilities/       # Permission capabilities
│   ├── resources/          # Bundled resources
│   └── src/
│       ├── lib.rs          # Entry point, plugin/command registration
│       ├── main.rs         # Binary entry (calls lib::run)
│       ├── commands/       # Tauri command handlers (mod.rs re-exports)
│       ├── managers/       # Core business logic managers
│       ├── settings.rs     # App settings with serde + store plugin
│       └── ...             # Domain-specific modules
```

## Architecture Patterns

For detailed pattern references with code examples, read `references/architecture.md`.

### Manager Pattern (Backend)

Core business logic is organized into **manager structs** that:
- Are initialized at app startup in `initialize_core_logic()`
- Wrap in `Arc<T>` for thread-safe shared ownership
- Register with Tauri's managed state via `app_handle.manage()`
- Are accessed in commands via `app.state::<Arc<ManagerType>>()`

### Command-Event Architecture

Communication flows between frontend and backend through:
- **Commands** (frontend → backend): Rust functions annotated with `#[tauri::command]`, registered in `collect_commands![]` macro
- **Events** (backend → frontend): Emitted via `app.emit("event-name", payload)`, listened via `app.listen()` or `listen()` from `@tauri-apps/api/event`

### Type-Safe Bindings (tauri-specta)

Use `tauri-specta` and `specta` for auto-generated TypeScript bindings:
- Annotate Rust commands with `#[specta::specta]` alongside `#[tauri::command]`
- Annotate types with `#[derive(Type)]` from specta
- Bindings export to `src/bindings.ts` in debug builds
- Frontend imports commands and types directly from `@/bindings`

### Frontend State Management

Use **Zustand** stores with `subscribeWithSelector` middleware:
- Stores wrap Tauri command calls for all backend interactions
- React hooks (`useSettings`, etc.) provide clean component APIs over stores
- Use `immer` for immutable state updates when dealing with complex nested state
- Listen for Tauri events inside stores to keep state synchronized

## Adding New Features

For step-by-step recipes with code examples, read `references/recipes.md`.

### Quick Reference: Adding a New Tauri Command

1. Create or extend a file in `src-tauri/src/commands/`
2. Annotate with `#[tauri::command]` and `#[specta::specta]`
3. Use `specta::Type` derive on any custom types
4. Register in `collect_commands![]` in `lib.rs`
5. Re-export from `commands/mod.rs` if in a submodule
6. Run `bun run tauri dev` to regenerate `src/bindings.ts`
7. Call from frontend via `commands.yourCommand()`

### Quick Reference: Adding a New Manager

1. Create `src-tauri/src/managers/your_manager.rs`
2. Define a struct with a `new(app_handle: &AppHandle) -> Result<Self>` constructor
3. Add `pub mod your_manager;` to `managers/mod.rs`
4. Instantiate in `initialize_core_logic()` in `lib.rs`
5. Register with `app_handle.manage(Arc::new(manager))`
6. Access in commands with `app.state::<Arc<YourManager>>()`

### Quick Reference: Adding a New Setting

1. Add the field to `AppSettings` struct in `settings.rs` with `#[serde(default)]`
2. Add the default value in `resources/default_settings.json`
3. Create a command to update it (pattern: `change_<setting>_setting`)
4. Register the command in `collect_commands![]`
5. Add the updater mapping in `settingUpdaters` in `stores/settingsStore.ts`
6. Create a UI component in `src/components/settings/`

## Configuration

### tauri.conf.json

Key configuration sections:
- `build`: Dev server URL, build commands (`beforeDevCommand`, `devUrl`, `beforeBuildCommand`, `frontendDist`)
- `app.windows[]`: Window definitions (label, size, visibility, resizable)
- `app.security`: CSP and asset protocol settings
- `bundle`: Platform-specific bundling (icons, signing, resources)
- `plugins`: Plugin-specific configuration (updater keys, etc.)

### Capabilities (capabilities/)

Tauri v2 uses a capability-based permission system:
- Define in `capabilities/default.json`
- Reference plugin permissions (e.g., `"core:default"`, `"fs:read-files"`)
- Scope file access with `fs:scope` identifier and allow/deny patterns
- Assign capabilities to specific windows by label

## Platform-Specific Development

Use Rust `cfg` attributes for platform-conditional code:
- `#[cfg(target_os = "macos")]` — macOS-specific code
- `#[cfg(target_os = "windows")]` — Windows-specific code
- `#[cfg(target_os = "linux")]` — Linux-specific code
- `#[cfg(unix)]` — Unix (macOS + Linux)

Common platform concerns:
- **macOS**: Activation policies (Regular vs Accessory for tray-only), entitlements, Metal GPU acceleration, accessibility permissions, hardened runtime
- **Windows**: Code signing, Vulkan acceleration, installer configuration
- **Linux**: GTK dependencies, AppImage bundling, deb/rpm packaging

## Development Commands

```bash
bun install                # Install frontend dependencies
bun run tauri dev          # Full dev mode (frontend + backend hot reload)
bun run tauri build        # Production build
bun run dev                # Frontend-only Vite dev server
bun run build              # TypeScript check + Vite build
bun run lint               # ESLint
bun run format             # Prettier + cargo fmt
```

## Key Dependencies

### Backend (Cargo.toml)
- `tauri` v2 — Core framework
- `serde` / `serde_json` — Serialization
- `specta` + `tauri-specta` — TypeScript binding generation
- `tauri-plugin-*` — Official plugins (store, fs, clipboard, os, log, etc.)
- `tokio` — Async runtime
- `anyhow` — Error handling
- `log` — Logging facade

### Frontend (package.json)
- `react` — UI framework
- `@tauri-apps/api` — Tauri JS API
- `@tauri-apps/plugin-*` — Plugin JS APIs
- `zustand` — State management
- `tailwindcss` — Styling
- `zod` — Schema validation
- `immer` — Immutable state updates
- `vite` — Build tool

## Resources

Detailed reference material for this skill:

- `references/architecture.md` — In-depth architecture patterns with code examples (Manager pattern, Command-Event system, state management, type bindings)
- `references/recipes.md` — Step-by-step implementation recipes for common tasks (new command, new manager, new setting, new plugin, events, tray menu, multi-window)
