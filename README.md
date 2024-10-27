# aptui
`aptui` is a simple command-line tool for installing packages. Just in case you're lazy to type ```sudo apt-get install <package>```. Don't ask why I made this. I don't know.

## Features
- **Support for most Linux distributions!**
- **Install packages:** Sooo revolutionary!
- **Remove packages:** Even more revolutionary!
- **List installed packages:** You never knew you needed this! (you don't)
- **Install from git:** Automatically clone and make a git repo. Pretty cool!
- **Search for packages:** Find packages by searching with keywords.
- Very similar UI to Network Manager TUI.

## Supported package managers and distros
### Package managers:
- APT-GET
- Pacman
- Yay
- DNF
- Zypper
- XBPS-Install
- EOPKG
### Distros
- Debian/Ubuntu (APT)
- Arch Linux (Pacman, Yay with AUR)
- Fedora (DNF)
- openSUSE (zypper)
- Void Linux (xbps-install)
- Solus (eopkg)
(I'll add more if requested)

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
### Alias (guide for bash users)
If you want, instead of going to the directory where the script is located you can create an alias so you can execute `aptui` anywhere you want.
Here's how to do this:
1. Open your terminal
2. Open your `.bashrc` or `.bash_profile` (both if your shell is bash) file in a text editor. This depends on your system:

   ```bash
   nano ~/.bashrc
   ```
   or

   ```bash
   nano ~/.bash_profile
   ```
3. Add the alias
   To add the alias add this line at the bottom of the file:
   
   ```bash
   alias aptui='/path/to/aptui.sh'
   ```
4. Save and exit.
5. To confirm the changes, run:

   ```bash
   source ~/.bashrc
   ```
   or

   ```bash
   source ~/.bash_profile
   ```

## License
This project is licensed under the MIT License.

## Contributions
Feel free to fork the repository and submit pull requests. Contributions are welcome!
(my code sucks, please help me)
