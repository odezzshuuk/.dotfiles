# Recipes

Step-by-step implementation guides for common Tauri v2 app development tasks.

## Recipe: Add a New Tauri Command

### Scenario
Add a `get_system_info` command that returns system information to the frontend.

### Steps

**1. Define types and command in `src-tauri/src/commands/`**

Create a new file or add to an existing one:

```rust
// src-tauri/src/commands/system.rs
use serde::Serialize;
use specta::Type;

#[derive(Serialize, Type)]
pub struct SystemInfo {
    pub os: String,
    pub arch: String,
    pub hostname: String,
}

#[tauri::command]
#[specta::specta]
pub fn get_system_info() -> Result<SystemInfo, String> {
    Ok(SystemInfo {
        os: std::env::consts::OS.to_string(),
        arch: std::env::consts::ARCH.to_string(),
        hostname: hostname::get()
            .map(|h| h.to_string_lossy().to_string())
            .unwrap_or_default(),
    })
}
```

**2. Register the module in `commands/mod.rs`**

```rust
pub mod system;
```

**3. Register in `collect_commands![]` in `lib.rs`**

```rust
let specta_builder = Builder::<tauri::Wry>::new().commands(collect_commands![
    // ... existing commands
    commands::system::get_system_info,
]);
```

**4. Rebuild to generate bindings**

```bash
bun run tauri dev
```

**5. Call from frontend**

```typescript
import { commands, type SystemInfo } from "@/bindings";

const result = await commands.getSystemInfo();
if (result.status === "ok") {
  const info: SystemInfo = result.data;
  console.log(info.os, info.arch);
}
```

---

## Recipe: Add a New Manager

### Scenario
Create a `NotificationManager` to handle desktop notifications.

### Steps

**1. Create `src-tauri/src/managers/notification.rs`**

```rust
use anyhow::Result;
use std::sync::Mutex;
use tauri::AppHandle;

pub struct NotificationManager {
    app_handle: AppHandle,
    history: Mutex<Vec<String>>,
}

impl NotificationManager {
    pub fn new(app_handle: &AppHandle) -> Result<Self> {
        Ok(Self {
            app_handle: app_handle.clone(),
            history: Mutex::new(Vec::new()),
        })
    }

    pub fn send(&self, message: &str) -> Result<()> {
        let mut history = self.history.lock().unwrap();
        history.push(message.to_string());
        log::info!("Notification: {}", message);
        Ok(())
    }

    pub fn get_history(&self) -> Vec<String> {
        self.history.lock().unwrap().clone()
    }
}
```

**2. Register in `managers/mod.rs`**

```rust
pub mod notification;
```

**3. Initialize in `lib.rs` `initialize_core_logic()`**

```rust
use managers::notification::NotificationManager;

fn initialize_core_logic(app_handle: &AppHandle) {
    // ... existing managers ...

    let notification_manager = Arc::new(
        NotificationManager::new(app_handle)
            .expect("Failed to initialize notification manager"),
    );
    app_handle.manage(notification_manager.clone());
}
```

**4. Use in commands**

```rust
use crate::managers::notification::NotificationManager;
use std::sync::Arc;
use tauri::{AppHandle, Manager};

#[tauri::command]
#[specta::specta]
pub fn send_notification(app: AppHandle, message: String) -> Result<(), String> {
    let manager = app.state::<Arc<NotificationManager>>();
    manager.send(&message).map_err(|e| e.to_string())
}
```

---

## Recipe: Add a New Setting

### Scenario
Add a `font_size` setting that controls text size in the UI.

### Steps

**1. Add field to `AppSettings` in `settings.rs`**

```rust
#[derive(Serialize, Deserialize, Debug, Clone, Type)]
pub struct AppSettings {
    // ... existing fields ...
    #[serde(default = "default_font_size")]
    pub font_size: u32,
}

fn default_font_size() -> u32 { 14 }
```

**2. Add default value in `resources/default_settings.json`**

```json
{
  "font_size": 14
}
```

**3. Create a change command (typically in `shortcut.rs` or a commands file)**

```rust
#[tauri::command]
#[specta::specta]
pub fn change_font_size_setting(app: AppHandle, font_size: u32) -> Result<(), String> {
    let mut settings = get_settings(&app);
    settings.font_size = font_size;
    write_settings(&app, settings);
    Ok(())
}
```

**4. Register in `collect_commands![]`**

**5. Add to `settingUpdaters` in `stores/settingsStore.ts`**

```typescript
const settingUpdaters: {
  [K in keyof Settings]?: (value: Settings[K]) => Promise<unknown>;
} = {
  // ... existing updaters ...
  font_size: (value) => commands.changeFontSizeSetting(value as number),
};
```

**6. Create the UI component**

```tsx
// src/components/settings/FontSize.tsx
import { useSettings } from "../../hooks/useSettings";

export const FontSize = () => {
  const { settings, updateSetting } = useSettings();

  return (
    <div className="flex items-center justify-between">
      <label>Font Size</label>
      <input
        type="number"
        min={10}
        max={24}
        value={settings?.font_size ?? 14}
        onChange={(e) => updateSetting("font_size", Number(e.target.value))}
      />
    </div>
  );
};
```

---

## Recipe: Add a Tauri Plugin

### Scenario
Add the `tauri-plugin-notification` plugin.

### Steps

**1. Add Rust dependency in `Cargo.toml`**

```toml
[dependencies]
tauri-plugin-notification = "2"
```

**2. Add JS dependency**

```bash
bun add @tauri-apps/plugin-notification
```

**3. Register plugin in `lib.rs`**

```rust
builder
    .plugin(tauri_plugin_notification::init())
    // ... other plugins
```

**4. Add permissions in `capabilities/default.json`**

```json
{
  "permissions": [
    "notification:default",
    "notification:allow-notify"
  ]
}
```

**5. Use from frontend**

```typescript
import { sendNotification } from "@tauri-apps/plugin-notification";

await sendNotification({ title: "Hello", body: "World" });
```

---

## Recipe: Emit and Listen to Events

### Scenario
Backend emits progress updates during a long operation; frontend displays them.

### Steps

**1. Define event payload and emit from Rust**

```rust
use serde::Serialize;
use tauri::{AppHandle, Emitter};

#[derive(Serialize, Clone)]
struct ProcessingProgress {
    step: String,
    percentage: f32,
    is_complete: bool,
}

fn process_data(app: &AppHandle) {
    for i in 0..100 {
        // Do work...
        let _ = app.emit("processing-progress", ProcessingProgress {
            step: format!("Processing item {}", i),
            percentage: i as f32,
            is_complete: i == 99,
        });
    }
}
```

**2. Listen from a Zustand store**

```typescript
import { listen } from "@tauri-apps/api/event";

// Inside store initialization
initialize: async () => {
    listen<{ step: string; percentage: number; is_complete: boolean }>(
        "processing-progress",
        (event) => {
            set({
                progressStep: event.payload.step,
                progressPercent: event.payload.percentage,
            });
            if (event.payload.is_complete) {
                set({ isProcessing: false });
            }
        },
    );
},
```

**3. Or listen from a React component**

```tsx
import { listen } from "@tauri-apps/api/event";
import { useEffect, useState } from "react";

const ProgressDisplay = () => {
  const [progress, setProgress] = useState(0);

  useEffect(() => {
    const unlisten = listen<{ percentage: number }>(
      "processing-progress",
      (event) => setProgress(event.payload.percentage),
    );
    return () => { unlisten.then((fn) => fn()); };
  }, []);

  return <div>Progress: {progress}%</div>;
};
```

---

## Recipe: System Tray Menu

### Scenario
Add a new item to the system tray context menu.

### Key Patterns

Tray menus are built in `lib.rs` via `TrayIconBuilder` with `.on_menu_event()`:

```rust
.on_menu_event(|app, event| match event.id.as_ref() {
    "settings" => {
        show_main_window(app);
    }
    "my_action" => {
        // Handle custom tray menu action
    }
    "quit" => {
        app.exit(0);
    }
    _ => {}
})
```

Tray menu items are typically managed through a utility function that rebuilds the menu. Update the tray menu builder to include new items.

---

## Recipe: Multi-Window Application

### Scenario
Add a secondary window (e.g., an overlay or popup).

### Steps

**1. Define the window in `tauri.conf.json`**

```json
{
  "app": {
    "windows": [
      {
        "label": "main",
        "title": "My App",
        "width": 680,
        "height": 570,
        "visible": true
      },
      {
        "label": "overlay",
        "title": "Overlay",
        "width": 300,
        "height": 100,
        "visible": false,
        "decorations": false,
        "transparent": true,
        "alwaysOnTop": true
      }
    ]
  }
}
```

**2. Add the window label to capabilities**

```json
{
  "windows": ["main", "overlay"],
  "permissions": ["core:default"]
}
```

**3. Create or show the window from Rust**

```rust
use tauri::Manager;

fn show_overlay(app: &AppHandle) {
    if let Some(window) = app.get_webview_window("overlay") {
        let _ = window.show();
        let _ = window.set_focus();
    }
}
```

**4. Create the window's frontend entry point**

For a separate HTML entry, create `src/overlay/index.html` and `src/overlay/main.tsx`, then configure in `vite.config.ts` as a multi-page app.

---

## Recipe: Error Handling Patterns

### Backend Errors

Commands return `Result<T, String>` for compatibility with the frontend:

```rust
#[tauri::command]
#[specta::specta]
pub fn risky_operation(app: AppHandle) -> Result<String, String> {
    // Convert anyhow errors to String
    internal_operation(&app).map_err(|e| format!("Operation failed: {}", e))
}

fn internal_operation(app: &AppHandle) -> anyhow::Result<String> {
    // Use anyhow internally for rich error context
    let data = std::fs::read_to_string("file.txt")
        .context("Failed to read configuration file")?;
    Ok(data)
}
```

### Frontend Error Handling

```typescript
const result = await commands.riskyOperation();
if (result.status === "error") {
  console.error("Backend error:", result.error);
  // Show toast notification, update error state, etc.
} else {
  const data = result.data;
}
```
