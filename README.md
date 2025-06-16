# qbx_sit

A clean and lightweight sit system made by **klof**, built with modern dependencies for Qbox-based servers.

## 💡 Features
- Uses `ox_target` for interactions
- Uses `ox_lib` for callbacks
- Uses `five-textui` for simple UI
- Supports any chair model (configurable)

## 🧩 Dependencies
- ox_lib
- ox_target
- five-textui ([https://github.com/cinquina/five-textui](https://github.com/cinquina/five-textui))

## 🛠️ Installation
1. Put the folder `qbx_sit` into your `resources` directory.
2. Add the following to your `server.cfg`:
   ```
   ensure qbx_sit
   ```
3. Make sure dependencies (`ox_lib`, `ox_target`, `five-textui`) are started before this script.

## ⚙️ Configuration
All chairs are defined in `config.lua`. Each entry supports:
- Model hash
- Animation
- Z offset (up or down)
- Optional offsets

## 🧪 Usage
Walk near a chair and press the target key to sit. Press `F` to stand.

---

Made with ❤️ by klof
