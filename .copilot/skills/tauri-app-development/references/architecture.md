# Architecture Patterns

Detailed architecture patterns for Tauri v2 applications with a Rust backend and React/TypeScript frontend.

## Manager Pattern

Managers encapsulate core business logic. Each manager is a Rust struct that owns its internal state and provides methods for operations.

### Manager Structure

```rust
use anyhow::Result;
use std::sync::Mutex;
use tauri::AppHandle;

pub struct MyManager {
    app_handle: AppHandle,
    // Internal state, often behind a Mutex for interior mutability
    state: Mutex<InternalState>,
}

struct InternalState {
    // Fields specific to this manager
    is_active: bool,
}

impl MyManager {
    /// Create a new manager instance. Called once at app startup.
    pub fn new(app_handle: &AppHandle) -> Result<Self> {
        Ok(Self {
            app_handle: app_handle.clone(),
            state: Mutex::new(InternalState { is_active: false }),
        })
    }

    /// Public method accessible from commands
    pub fn do_something(&self) -> Result<String> {
        let mut state = self.state.lock().unwrap();
        state.is_active = true;
        Ok("Done".to_string())
    }
}
```

### Manager Registration

Managers are initialized in `lib.rs` inside `initialize_core_logic()` and wrapped in `Arc` for thread-safe shared access:

```rust
use std::sync::Arc;

fn initialize_core_logic(app_handle: &AppHandle) {
    let my_manager = Arc::new(
        MyManager::new(app_handle).expect("Failed to initialize my manager"),
    );
    app_handle.manage(my_manager.clone());
}
```

### Accessing Managers in Commands

```rust
use std::sync::Arc;
use tauri::{AppHandle, Manager};

#[tauri::command]
#[specta::specta]
pub fn do_something(app: AppHandle) -> Result<String, String> {
    let manager = app.state::<Arc<MyManager>>();
    manager.do_something().map_err(|e| e.to_string())
}
```

## Command-Event Architecture

### Commands (Frontend → Backend)

Commands are Rust functions callable from the frontend. They follow this pattern:

```rust
use serde::{Deserialize, Serialize};
use specta::Type;
use tauri::AppHandle;

// Custom types must derive Serialize and Type for specta
#[derive(Serialize, Deserialize, Debug, Clone, Type)]
pub struct MyResponse {
    pub id: String,
    pub name: String,
    pub is_active: bool,
}

#[tauri::command]
#[specta::specta]
pub fn get_items(app: AppHandle) -> Result<Vec<MyResponse>, String> {
    // Access state, perform logic, return result
    Ok(vec![MyResponse {
        id: "1".to_string(),
        name: "Item 1".to_string(),
        is_active: true,
    }])
}

// Commands with parameters
#[tauri::command]
#[specta::specta]
pub fn update_item(app: AppHandle, id: String, name: String) -> Result<(), String> {
    // Parameters are automatically deserialized from the frontend call
    Ok(())
}
```

**Command registration** — All commands must be listed in the `collect_commands![]` macro in `lib.rs`:

```rust
let specta_builder = Builder::<tauri::Wry>::new().commands(collect_commands![
    commands::get_items,
    commands::update_item,
    // Submodule commands use :: path notation
    commands::models::get_available_models,
]);
```

**Command module structure** — Organize commands in `src/commands/` with a `mod.rs` re-exporting submodules:

```rust
// commands/mod.rs
pub mod audio;
pub mod models;
pub mod transcription;

// Top-level commands can be defined directly here
#[tauri::command]
#[specta::specta]
pub fn get_app_dir_path(app: AppHandle) -> Result<String, String> {
    // ...
}
```

### Events (Backend → Frontend)

Use events for asynchronous notifications from backend to frontend:

```rust
use tauri::{AppHandle, Emitter};
use serde::Serialize;

#[derive(Serialize, Clone)]
struct ProgressPayload {
    percentage: f32,
    message: String,
}

// Emit from anywhere with an AppHandle
fn notify_progress(app: &AppHandle, progress: f32) {
    let _ = app.emit("download-progress", ProgressPayload {
        percentage: progress,
        message: format!("{}% complete", progress),
    });
}
```

**Listening on the frontend:**

```typescript
import { listen } from "@tauri-apps/api/event";

interface ProgressPayload {
  percentage: number;
  message: string;
}

// In a store or component
const unlisten = await listen<ProgressPayload>("download-progress", (event) => {
  console.log(event.payload.percentage);
});

// Clean up when done
unlisten();
```

**Listening on the backend:**

```rust
use tauri::Listener;

app_handle.listen("some-event", move |event| {
    // Handle event
});
```

## Type-Safe Bindings with tauri-specta

### Setup

In `Cargo.toml`:
```toml
specta = "=2.0.0-rc.22"
specta-typescript = "0.0.9"
tauri-specta = { version = "=2.0.0-rc.21", features = ["derive", "typescript"] }
```

In `lib.rs`, the specta builder is configured to export bindings:
```rust
use specta_typescript::{BigIntExportBehavior, Typescript};
use tauri_specta::{collect_commands, Builder};

let specta_builder = Builder::<tauri::Wry>::new()
    .commands(collect_commands![/* all commands */]);

#[cfg(debug_assertions)]
specta_builder
    .export(
        Typescript::default().bigint(BigIntExportBehavior::Number),
        "../src/bindings.ts",
    )
    .expect("Failed to export typescript bindings");
```

### Deriving Types

All types used in command signatures must derive `specta::Type`:

```rust
use serde::{Deserialize, Serialize};
use specta::Type;

#[derive(Serialize, Deserialize, Debug, Clone, Type)]
pub struct AudioDevice {
    pub index: String,
    pub name: String,
    pub is_default: bool,
}

// Enums with serde rename
#[derive(Serialize, Debug, Clone, Copy, PartialEq, Eq, Type)]
#[serde(rename_all = "lowercase")]
pub enum LogLevel {
    Trace,
    Debug,
    Info,
    Warn,
    Error,
}
```

### Frontend Usage

The generated `bindings.ts` exports:
- `commands` object with all command functions
- All Rust types as TypeScript interfaces/types

```typescript
import { commands, type AudioDevice, type ModelInfo } from "@/bindings";

// Commands return Result-like objects
const result = await commands.getAvailableModels();
if (result.status === "ok") {
  const models: ModelInfo[] = result.data;
}
```

## Frontend State Management (Zustand)

### Store Pattern

```typescript
import { create } from "zustand";
import { subscribeWithSelector } from "zustand/middleware";
import { commands, type MyType } from "@/bindings";

interface MyStore {
  // State
  items: MyType[];
  loading: boolean;
  error: string | null;

  // Actions
  initialize: () => Promise<void>;
  loadItems: () => Promise<void>;
  updateItem: (id: string, value: string) => Promise<void>;

  // Internal setters
  setItems: (items: MyType[]) => void;
  setLoading: (loading: boolean) => void;
  setError: (error: string | null) => void;
}

export const useMyStore = create<MyStore>()(
  subscribeWithSelector((set, get) => ({
    items: [],
    loading: true,
    error: null,

    setItems: (items) => set({ items }),
    setLoading: (loading) => set({ loading }),
    setError: (error) => set({ error }),

    initialize: async () => {
      await get().loadItems();
      // Set up event listeners
      const { listen } = await import("@tauri-apps/api/event");
      listen("items-changed", () => get().loadItems());
    },

    loadItems: async () => {
      try {
        const result = await commands.getItems();
        if (result.status === "ok") {
          set({ items: result.data, error: null });
        }
      } catch (e) {
        set({ error: String(e) });
      } finally {
        set({ loading: false });
      }
    },

    updateItem: async (id, value) => {
      const result = await commands.updateItem(id, value);
      if (result.status === "ok") {
        await get().loadItems(); // Refresh after update
      }
    },
  })),
);
```

### Hook Pattern

Wrap stores in custom hooks for cleaner component APIs:

```typescript
import { useEffect } from "react";
import { useMyStore } from "../stores/myStore";

export const useMyFeature = () => {
  const store = useMyStore();

  useEffect(() => {
    if (store.loading) {
      store.initialize();
    }
  }, [store.initialize, store.loading]);

  return {
    items: store.items,
    isLoading: store.loading,
    updateItem: store.updateItem,
  };
};
```

## Settings System

### Backend Settings Structure

Settings use `tauri-plugin-store` for persistent storage:

```rust
use serde::{Deserialize, Serialize};
use specta::Type;
use tauri::AppHandle;
use tauri_plugin_store::StoreExt;

#[derive(Serialize, Deserialize, Debug, Clone, Type)]
pub struct AppSettings {
    pub my_setting: bool,
    #[serde(default)]
    pub optional_setting: Option<String>,
    #[serde(default = "default_volume")]
    pub volume: f32,
}

fn default_volume() -> f32 { 0.5 }

pub fn get_settings(app: &AppHandle) -> AppSettings {
    let store = app.store("settings.json").expect("Failed to open store");
    // Read from store, merge with defaults
    // ...
}

pub fn write_settings(app: &AppHandle, settings: AppSettings) {
    let store = app.store("settings.json").expect("Failed to open store");
    store.set("settings", serde_json::to_value(&settings).unwrap());
    store.save().ok();
}
```

### Frontend Settings Integration

The `settingsStore.ts` maps setting keys to command updaters:

```typescript
const settingUpdaters: {
  [K in keyof Settings]?: (value: Settings[K]) => Promise<unknown>;
} = {
  my_setting: (value) => commands.changeMySettingSetting(value as boolean),
  volume: (value) => commands.changeVolumeSetting(value as number),
};
```

## Capability-Based Permissions (Tauri v2)

Capabilities define what APIs a window can access:

```json
{
  "$schema": "../gen/schemas/desktop-schema.json",
  "identifier": "default",
  "description": "Capabilities for the app",
  "windows": ["main"],
  "permissions": [
    "core:default",
    "opener:default",
    "store:default",
    "fs:read-files",
    {
      "identifier": "fs:scope",
      "allow": [
        { "path": "$APPDATA" },
        { "path": "$APPDATA/**/*" }
      ]
    }
  ]
}
```

When adding a new plugin, ensure its permissions are included in the capability file.
