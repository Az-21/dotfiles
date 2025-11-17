"""
Dotfiles Installation Script


Automatically installs dotfiles for Linux, macOS, and Windows.
- Uses symlinks for Linux/macOS
- Copies files for Windows
- Appends content if file starts with ">>> APPEND <<<"
"""

import os
import platform
import shutil
from enum import Enum
from pathlib import Path

APPEND_MODE_TARGET: str = ">>>append<<<"
DIVIDER: str = "=" * 60


class OperatingSystem(Enum):
    Linux = "linux"
    MacOS = "macos"
    Windows = "windows"


def detect_os() -> OperatingSystem:
    """Detect the operating system"""
    system: str = platform.system().lower()
    if system == "linux":
        return OperatingSystem.Linux
    elif system == "darwin":
        return OperatingSystem.MacOS
    elif system == "windows":
        return OperatingSystem.Windows
    else:
        # This will propagate up and stop the script
        raise Exception(f"Unsupported operating system: {system}")


def should_append(file_path) -> bool:
    """Check if the file's first line contains `APPEND_MODE_TARGET`"""
    with open(file_path, "r", encoding="utf-8") as f:
        first_line: str = f.readline()
        processed_line: str = "".join(first_line.lower().split())
        return APPEND_MODE_TARGET in processed_line


def read_file_content(file_path, skip_first_line=False) -> str:
    """Read file content, optionally skipping the first line"""
    with open(file_path, "r", encoding="utf-8") as f:
        if skip_first_line:
            f.readline()  # Skip first line
        return f.read()


def append_to_file(source, destination) -> None:
    """Append content from source to destination file, checking for existing lines to avoid duplicates."""
    print(f"  Appending: {source} -> {destination}")

    # Create parent directory if it doesn't exist
    destination.parent.mkdir(parents=True, exist_ok=True)

    # Read content to be appended (skip first line in append mode)
    content_to_append: str = read_file_content(source, skip_first_line=True)

    # Get lines from source, filtering out empty ones
    source_lines: list[str] = [
        line for line in content_to_append.splitlines() if line.strip()
    ]

    if not source_lines:
        print("  ✓ Source file is empty (or only has header). Nothing to append.")
        return

    # Read existing destination lines into a set for fast lookup
    existing_lines_set: set[str] = set()
    if destination.exists():
        existing_content: str = read_file_content(destination)
        existing_lines_set = set(existing_content.splitlines())

    # Determine which lines are new
    lines_to_write: list[str] = []
    for line in source_lines:
        if line not in existing_lines_set:
            lines_to_write.append(line)

    if not lines_to_write:
        print("  ✓ Content already up-to-date")
        return

    # Append the new lines
    with open(destination, "a", encoding="utf-8") as f:
        # Add newline if file exists and doesn't end with one
        if destination.exists() and destination.stat().st_size > 0:
            with open(destination, "rb") as check:
                check.seek(-1, 2)
                if check.read(1) != b"\n":
                    f.write("\n")

        # Write the new content
        content_to_write: str = "\n".join(lines_to_write)
        f.write(content_to_write)

        # Add a final newline if the original source content block had one
        if content_to_append.endswith("\n"):
            f.write("\n")

    print(f"  ✓ Appended {len(lines_to_write)} new line(s) successfully")


def create_symlink(source, destination, force=True) -> None:
    """Create a symlink from source to destination."""
    print(f"  Symlinking: {source} -> {destination}")

    destination.parent.mkdir(parents=True, exist_ok=True)

    if force and destination.exists():
        if destination.is_symlink() or destination.is_file():
            destination.unlink()
        elif destination.is_dir():
            shutil.rmtree(destination)

    os.symlink(source.resolve(), destination)
    print("  ✓ Symlink created")


def copy_file(source, destination) -> None:
    """Copy file from source to destination."""
    print(f"  Copying: {source} -> {destination}")

    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, destination)
    print("  ✓ File copied")


def install_dotfiles(os_name: OperatingSystem) -> None:
    """Install dotfiles for the detected operating system"""
    script_dir: Path = Path(__file__).parent.parent  # Go up to project root
    os_dir: Path = script_dir / os_name.value
    home_dir: Path = Path.home()

    print("\n" + DIVIDER)
    print(f"Installing dotfiles for {os_name.value.upper()}\n")
    print(f"Repo directory                :: {script_dir}")
    print(f"Dotfile source directory      :: {os_dir}")
    print(f"Dotfile destination directory :: {home_dir}")
    print(DIVIDER + "\n")

    # Wait for confirmation by user
    print("Continue? [y/N]: ", sep="", end="")
    if input() != "y":
        print("\nInstallation aborted by user")
        return

    if not os_dir.exists():
        print(f"No dotfiles found for {os_name.value} at {os_dir}")
        return

    # Walk through all files in the OS-specific directory
    for source_file in os_dir.rglob("*"):
        if source_file.is_file():
            # Calculate relative path from os_dir
            rel_path: Path = source_file.relative_to(os_dir)

            # Determine destination path
            destination: Path = home_dir / rel_path

            print(f"\nProcessing: {rel_path}")

            # Check if file should be appended
            if should_append(source_file):
                append_to_file(source_file, destination)
            else:
                # Create symlink for Linux and macOS
                if os_name in {OperatingSystem.Linux, OperatingSystem.MacOS}:
                    create_symlink(source_file, destination, force=True)
                else:
                    copy_file(source_file, destination)

    print("✓ Dotfiles installation complete!")


def main() -> None:
    """Main function."""
    os_name: OperatingSystem = detect_os()
    install_dotfiles(os_name)


if __name__ == "__main__":
    main()
