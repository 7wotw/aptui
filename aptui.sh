#!/bin/bash

CONFIG_DIR="$HOME/.config/aptui"
CONFIG_FILE="$CONFIG_DIR/aptui.conf"

mkdir -p "$CONFIG_DIR"

select_distro() {
    DISTRO=$(dialog --menu "Select your distribution:" 14 50 8 \
        1 "Debian/Ubuntu (apt-get)" \
        2 "Arch Linux (pacman)" \
        3 "Arch Linux with AUR (yay)" \
        4 "Fedora (dnf)" \
        5 "openSUSE (zypper)" \
        6 "Void Linux (xbps-install)" \
        7 "Solus (eopkg)" \
        8 "Auto-detect" 3>&1 1>&2 2>&3)

    case $DISTRO in
        1) PACKAGE_MANAGER="apt-get" ;;
        2) PACKAGE_MANAGER="pacman" ;;
        3) PACKAGE_MANAGER="yay" ;;
        4) PACKAGE_MANAGER="dnf" ;;
        5) PACKAGE_MANAGER="zypper" ;;
        6) PACKAGE_MANAGER="xbps-install" ;;
        7) PACKAGE_MANAGER="eopkg" ;;
        8) 
            DISTRO_INFO=$(lsb_release -is)
            case "$DISTRO_INFO" in
                Debian|Ubuntu) PACKAGE_MANAGER="apt-get" ;;
                Arch) PACKAGE_MANAGER="pacman" ;;
                Fedora) PACKAGE_MANAGER="dnf" ;;
                openSUSE) PACKAGE_MANAGER="zypper" ;;
                Void) PACKAGE_MANAGER="xbps-install" ;;
                Solus) PACKAGE_MANAGER="eopkg" ;;
                *) dialog --msgbox "Could not auto-detect the package manager." 6 40; exit 1 ;;
            esac
            ;;
        *) dialog --msgbox "Invalid selection. Exiting." 6 40; exit 1 ;;
    esac

    # Confirm selection
    dialog --yesno "You selected: $PACKAGE_MANAGER. Is this correct?" 7 50
    if [ $? -eq 0 ]; then
        echo "PACKAGE_MANAGER=$PACKAGE_MANAGER" > "$CONFIG_FILE"
        dialog --msgbox "Configuration saved to $CONFIG_FILE" 6 50
    else
        dialog --msgbox "Selection cancelled." 6 40
        exit 1
    fi
}

if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    select_distro
fi

is_package_installed() {
    case "$PACKAGE_MANAGER" in
        apt-get) dpkg -l | grep -q "^ii\s*$1" ;;
        pacman) pacman -Q "$1" >/dev/null 2>&1 ;;
        yay) yay -Q "$1" >/dev/null 2>&1 ;;
        dnf) dnf list installed "$1" >/dev/null 2>&1 ;;
        zypper) zypper se --installed-only "$1" >/dev/null 2>&1 ;;
        xbps-install) xbps-query -Rs "$1" >/dev/null 2>&1 ;;
        eopkg) eopkg list-installed | grep -q "^$1" ;;
    esac
}

install_package() {
    PACKAGE=$(dialog --inputbox "Enter the package name to install:" 8 40 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        if is_package_installed "$PACKAGE"; then
            dialog --msgbox "Package '$PACKAGE' is already installed." 6 40
        else
            dialog --yesno "Are you sure you want to install package '$PACKAGE'?" 6 40
            if [ $? -eq 0 ]; then
                clear
                echo "Installing package '$PACKAGE'..."
                case "$PACKAGE_MANAGER" in
                    apt-get) sudo apt-get install -y "$PACKAGE" ;;
                    pacman) sudo pacman -S --noconfirm "$PACKAGE" ;;
                    yay) yay -S --noconfirm "$PACKAGE" ;;
                    dnf) sudo dnf install -y "$PACKAGE" ;;
                    zypper) sudo zypper install -y "$PACKAGE" ;;
                    xbps-install) sudo xbps-install -y "$PACKAGE" ;;
                    eopkg) sudo eopkg install -y "$PACKAGE" ;;
                esac
                if [ $? -eq 0 ]; then
                    dialog --msgbox "Package '$PACKAGE' installed successfully." 6 40
                else
                    dialog --msgbox "Failed to install package '$PACKAGE'." 6 40
                fi
            else
                dialog --msgbox "Installation cancelled." 6 40
            fi
        fi
    else
        dialog --msgbox "Installation cancelled." 6 40
    fi
}

remove_package() {
    PACKAGE=$(dialog --inputbox "Enter the package name to remove:" 8 40 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        if ! is_package_installed "$PACKAGE"; then
            dialog --msgbox "Package '$PACKAGE' is not installed." 6 40
        else
            dialog --yesno "Are you sure you want to remove package '$PACKAGE'?" 6 40
            if [ $? -eq 0 ]; then
                clear
                echo "Removing package '$PACKAGE'..."
                case "$PACKAGE_MANAGER" in
                    apt-get) sudo apt-get remove --purge -y "$PACKAGE" ;;
                    pacman) sudo pacman -Rsn --noconfirm "$PACKAGE" ;;
                    yay) yay -Rns --noconfirm "$PACKAGE" ;;
                    dnf) sudo dnf remove -y "$PACKAGE" ;;
                    zypper) sudo zypper remove -y "$PACKAGE" ;;
                    xbps-install) sudo xbps-remove -R "$PACKAGE" ;;
                    eopkg) sudo eopkg rm -y "$PACKAGE" ;;
                esac

                if [ $? -eq 0 ]; then
                    dialog --msgbox "Package '$PACKAGE' removed successfully." 6 40
                else
                    dialog --msgbox "Failed to remove package '$PACKAGE'." 6 40
                fi
            else
                dialog --msgbox "Removal cancelled." 6 40
            fi
        fi
    else
        dialog --msgbox "Removal cancelled." 6 40
    fi
}

list_installed_packages() {
    case "$PACKAGE_MANAGER" in
        apt-get) INSTALLED_PACKAGES=$(dpkg-query -f '${binary:Package}\n' -W) ;;
        pacman) INSTALLED_PACKAGES=$(pacman -Q) ;;
        yay) INSTALLED_PACKAGES=$(yay -Q) ;;
        dnf) INSTALLED_PACKAGES=$(dnf list installed | awk 'NR>1 {print $1}') ;;
        zypper) INSTALLED_PACKAGES=$(zypper se --installed-only | awk '{print $2}') ;;
        xbps-install) INSTALLED_PACKAGES=$(xbps-query -Rs | awk '{print $2}') ;;
        eopkg) INSTALLED_PACKAGES=$(eopkg list-installed | awk '{print $1}') ;;
    esac

    if [ -z "$INSTALLED_PACKAGES" ]; then
        dialog --msgbox "No installed packages found." 6 40
    else
        PACKAGE_LIST=$(echo "$INSTALLED_PACKAGES" | nl -w2 -s' ')
        SELECTED_PACKAGE=$(dialog --no-cancel --menu "Installed Packages" 20 60 20 $PACKAGE_LIST 3>&1 1>&2 2>&3)
        exitstatus=$?
    fi
}

search_package() {
    QUERY=$(dialog --inputbox "Enter the package name or keyword to search:" 8 40 3>&1 1>&2 2>&3)
    exitstatus=$?
    
    if [ $exitstatus = 0 ]; then
        case "$PACKAGE_MANAGER" in
            apt-get) SEARCH_RESULTS=$(apt-cache search "$QUERY") ;;
            pacman) SEARCH_RESULTS=$(pacman -Ss "$QUERY") ;;
            yay) SEARCH_RESULTS=$(yay -Ss "$QUERY") ;;
            dnf) SEARCH_RESULTS=$(dnf search "$QUERY") ;;
            zypper) SEARCH_RESULTS=$(zypper se "$QUERY") ;;
            xbps-install) SEARCH_RESULTS=$(xbps-query -Rs "$QUERY") ;;
            eopkg) SEARCH_RESULTS=$(eopkg search "$QUERY") ;;
        esac
        
        MENU_ITEMS=()
        while read -r line; do
            PACKAGE_NAME=$(echo "$line" | awk '{print $1}') 
            PACKAGE_DESC=$(echo "$line" | cut -d' ' -f2-) 
            MENU_ITEMS+=("$PACKAGE_NAME" "$PACKAGE_DESC")
        done <<< "$SEARCH_RESULTS"

        dialog --no-cancel --menu "Search results:" 20 80 "${#MENU_ITEMS[@]}" "${MENU_ITEMS[@]}"
        
    else
        dialog --msgbox "Search cancelled." 6 40
    fi
}


install_from_git() {
    REPO_URL=$(dialog --inputbox "Enter the Git repository URL:" 8 40 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        TEMP_DIR=$(mktemp -d)
        cd "$TEMP_DIR" || { dialog --msgbox "Failed to change directory." 6 40; return; }

        git clone "$REPO_URL" temp_repo
        if [ $? -eq 0 ]; then
            cd temp_repo || { dialog --msgbox "Failed to change directory to temp_repo." 6 40; return; }
            if [ -f "install.sh" ]; then
                dialog --yesno "Found 'install.sh'. Do you want to run it?" 6 40
                if [ $? -eq 0 ]; then
                    bash install.sh
                    if [ $? -eq 0 ]; then
                        dialog --msgbox "Installation from Git completed successfully." 6 40
                    else
                        dialog --msgbox "Failed to run 'install.sh'." 6 40
                    fi
                fi
            else
                dialog --msgbox "'install.sh' not found. You may need to install manually." 6 40
            fi
            cd ..
            rm -rf temp_repo 
        else
            dialog --msgbox "Failed to clone repository." 6 40
        fi
    else
        dialog --msgbox "Input cancelled." 6 40
    fi
}

show_menu() {
    while true; do
        CHOICE=$(dialog --no-cancel --menu "APTUI Package Manager (using: $PACKAGE_MANAGER)" 14 60 8 \
            1 "Install a package" \
            2 "Remove a package" \
            3 "List installed packages" \
            4 "Search for a package" \
            5 "Install from Git" \
            6 "Exit" 3>&1 1>&2 2>&3)

        exitstatus=$?
        if [ $exitstatus = 0 ]; then
            case $CHOICE in
                1) install_package ;;
                2) remove_package ;;
                3) list_installed_packages ;;
                4) search_package ;;
                5) install_from_git ;;
                6) break ;;
                *) dialog --msgbox "Invalid option." 6 40 ;;
            esac
        else
            break
        fi
    done
}

show_menu
clear
