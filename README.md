# aptui

`aptui` is a simple, interactive command-line utility for managing packages on Debian-based systems. It provides a dialog-based interface to install, remove, search, and list packages.

## Features

- **Install packages:** Easily install packages by providing their name.
- **Remove packages:** Uninstall packages from your system.
- **List installed packages:** View a list of all packages currently installed.
- **List available packages:** Browse all available packages in the repository.
- **Search for packages:** Find packages by searching with keywords.

## Prerequisites

- `dialog` package (for creating the UI dialogs)
  
  Install `dialog` if you haven't already:
  ```bash
  sudo apt-get install dialog
  ```

## Installation

Clone this repository and make `aptui` executable:
```bash
git clone https://github.com/hitofuki/aptui.git
cd aptui
chmod +x aptui.sh
```

## Usage

Run `aptui` with the following command:
```bash
./aptui.sh
```

Use the menu to navigate through the following options:
1. **Install a package**
2. **Remove a package**
3. **List installed packages**
4. **List available packages**
5. **Search for a package**
6. **Exit**

## Code Overview

The script defines the following functions:
- `is_package_installed()`: Checks if a package is already installed.
- `install_package()`: Prompts for a package name and installs it.
- `remove_package()`: Prompts for a package name and removes it.
- `list_installed_packages()`: Displays a list of installed packages.
- `list_available_packages()`: Displays a list of available packages.
- `search_package()`: Searches for packages based on a search term.
- `show_menu()`: Displays the main menu and handles user choices.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contributions

Feel free to fork the repository and submit pull requests. Contributions are welcome!
