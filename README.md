# aptui
`aptui` is a simple command-line tool for installing packages. Just in case you're lazy to type ```sudo apt-get install <package>```

## Features
- **Install packages:** Sooo revolutionary!
- **Remove packages:** Even more revolutionary!
- **List installed packages:** You never knew you needed this! (you don't)
- **Install from git:** Automatically clone and make a git repo. Pretty cool!
- **Search for packages:** Find packages by searching with keywords.

## Requirements
- `dialog` package (for creating the UI)
  
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
4. **Install from Git**
5. **Search for a package**
6. **Exit**

## Some cool things
### The git cloning works like this:
1. The script creates a temporary directory to clone the git repo into.
2. Checks if `install.sh` or `makefile` exist.
3. Runs either `install.sh` or `makefile` and builds the package.
4. Cleans everything up.

## License
This project is licensed under the MIT License.

## Contributions
Feel free to fork the repository and submit pull requests. Contributions are welcome!
(my code sucks, please help me)
