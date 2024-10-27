#!/bin/bash

is_package_installed() {
    dpkg -l | grep -q "^ii\s*$1"
}

install_package() {
    PACKAGE=$(dialog --inputbox "Enter the package name to install:" 8 40 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        if is_package_installed "$PACKAGE"; then
            dialog --msgbox "Package '$PACKAGE' is already installed." 6 40
        else
            clear
            echo "Installing package '$PACKAGE'..."
            if sudo apt-get install -y "$PACKAGE"; then
                clear
                dialog --msgbox "Package '$PACKAGE' installed successfully." 6 40
            else
                clear
                dialog --msgbox "Failed to install package '$PACKAGE'." 6 40
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
            clear
            echo "Removing package '$PACKAGE'..."
            if sudo apt-get remove -y "$PACKAGE"; then
                clear
                dialog --msgbox "Package '$PACKAGE' removed successfully." 6 40
            else
                clear
                dialog --msgbox "Failed to remove package '$PACKAGE'." 6 40
            fi
        fi
    else
        dialog --msgbox "Removal cancelled." 6 40
    fi
}

list_installed_packages() {
    PACKAGES=$(dpkg-query -W --showformat='${Package}\n' | sort)  
    TEMP_FILE=$(mktemp)
    echo -e "Installed Packages:\n\n$PACKAGES" > "$TEMP_FILE"
    dialog --textbox "$TEMP_FILE" 20 70
    rm -f "$TEMP_FILE"
}

list_available_packages() {
    AVAILABLE_PACKAGES=$(apt-cache pkgnames | column)
    TEMP_FILE=$(mktemp)
    echo -e "Available Packages:\n\n$AVAILABLE_PACKAGES" > "$TEMP_FILE"
    dialog --textbox "$TEMP_FILE" 20 70
    rm -f "$TEMP_FILE"
}

search_package() {
    SEARCH_TERM=$(dialog --inputbox "Enter the search term for packages:" 8 40 3>&1 1>&2 2>&3)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        SEARCH_RESULTS=$(apt-cache search "$SEARCH_TERM" | awk '{print $1, $2}' | column)
        TEMP_FILE=$(mktemp)
        if [ -z "$SEARCH_RESULTS" ]; then
            dialog --msgbox "No packages found matching '$SEARCH_TERM'." 6 40
        else
            echo -e "Search Results for '$SEARCH_TERM':\n\n$SEARCH_RESULTS" > "$TEMP_FILE"
            dialog --textbox "$TEMP_FILE" 20 70
        fi
        rm -f "$TEMP_FILE"
    else
        dialog --msgbox "Search cancelled." 6 40
    fi
}

show_menu() {
    while true; do
        CHOICE=$(dialog --menu "Package Manager" 15 60 6 \
            1 "Install a package" \
            2 "Remove a package" \
            3 "List installed packages" \
            4 "List available packages" \
            5 "Search for a package" \
            6 "Exit" 3>&1 1>&2 2>&3)

        exitstatus=$?
        if [ $exitstatus = 0 ]; then
            case $CHOICE in
                1) install_package ;;
                2) remove_package ;;
                3) list_installed_packages ;;
                4) list_available_packages ;;
                5) search_package ;;
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

