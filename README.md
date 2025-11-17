# Dotfiles

## Symlink
This repo uses symlinks to reduce duplication. Since Windows does not support symlink OOTB, clone the repo with `core.symlinks=true` to enable symlink for its clone folder specifically.

```powershell
git clone -c core.symlinks=true https://github.com/Az-21/dotfiles.git
```

## Installation
This python script detects the OS and installs the dotfiles automatically.

It works off the assumption that all dotfiles will be placed relative to `$HOME`/`~`.

```py
cd ./install
uv sync
uv run main.py
```

> [!NOTE]
> - On Linux and macOS, dotfiles are created using symlink.
> - On Windows, dotfiles are copy-pasted.

> [!WARNING]
> - Do not delete this repo after running the script on Linux and macOS.
> - If you move the repo, re-run the script to recalculate the symlinks on Linux and macOS.

> [!CAUTION]
> This script has an _append mode_ which gets activated if the first line of the dotfile contains `>>> APPEND <<<` (case insensitive + space insensitive).
> This is useful for files like `.bashrc` which can vary a lot distro-to-distro.
> - Standard mode: if dotfile already exists at destination, it is **overwritten**.
> - Append mode: script gets the `diff` between source dotfile and destination dotfile, and only adds the required lines. Symlink is **not** created in this mode.
