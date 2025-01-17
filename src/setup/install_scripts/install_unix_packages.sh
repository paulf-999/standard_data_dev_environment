#!/bin/bash

#=======================================================================
# Function Name: install_unix_packages
# Description: Installs Unix packages listed in unix_packages.txt
#              while skipping certain packages for macOS.
#=======================================================================

#=======================================================================
# Variables
#=======================================================================

# Source shell_utils.sh relative to this script
source "${SHELL_UTILS_PATH}"

# List of packages to skip on macOS
MAC_OS_SKIP_PACKAGES=("build-essential" "openjdk-11-jre" "ruby-full" "wslu")

#=======================================================================
# Helper Functions
#=======================================================================

# Function to update Unix packages
update_unix_packages() {
    log_message "${DEBUG_DETAILS}" "Updating Unix package list..."
    sudo apt-get -yqq update || {
        log_message "${ERROR}" "Failed to update Unix packages."
        exit 1
    }
}

# Function to install Unix packages
install_unix_packages_linux() {
    log_message "${DEBUG_DETAILS}" "Installing Unix packages..."
    sudo apt -yqq install "$(cat ${INSTALL_DEP_DIR}/unix_packages.txt)" || {
        log_message "${ERROR}" "Failed to install Unix packages via apt."
        exit 1
    }
}

# Function to install development tools for macOS
install_dev_tools_macos() {
    log_message "${DEBUG_DETAILS}" "Installing development tools on macOS..."
    brew install gcc make > /dev/null 2>&1 || {
        log_message "${ERROR}" "Failed to install macOS development tools."
        exit 1
    }
}

# Function to install packages on macOS using Homebrew
install_unix_packages_macos() {
    log_message "${DEBUG_DETAILS}" "Installing Unix-like packages on macOS..."

    # Install other packages listed in the unix_packages.txt (excluding those in MAC_OS_SKIP_PACKAGES)
    while read -r package; do
        # Check if the package is in the MAC_OS_SKIP_PACKAGES array
        package_found=false
        for skip_package in "${MAC_OS_SKIP_PACKAGES[@]}"; do
            if [[ "$skip_package" == "$package" ]]; then
                package_found=true
                break
            fi
        done

        if [[ "$package_found" == true ]]; then
            log_message "${DEBUG}" "Skipping installation of $package."
            continue  # Skip the problematic package
        fi

        # log_message "${DEBUG_DETAILS}" "Installing package: $package"
        if ! brew install "$package" > /dev/null 2>&1; then
            log_message "${ERROR}" "Failed to install package: $package via Homebrew."
            exit 1
        fi
    done < ${INSTALL_DEP_DIR}/unix_packages.txt
}

# Function to install Unix packages (Master function)
install_unix_packages() {

    # Inform the user about the sudo password prompt
    log_message "${DEBUG_DETAILS}" "Note: You will be prompted for your sudo password during package installation."

    # Check for OS and use appropriate package manager
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        update_unix_packages       # Step 1: Update Unix packages
        install_unix_packages_linux  # Step 2: Install packages using apt

    elif [[ "$OSTYPE" == "darwin"* ]]; then
        log_message "${DEBUG_DETAILS}" "Prerequisite step: update Homebrew"
        brew update  # Ensure Homebrew is up-to-date

        install_dev_tools_macos  # Step 1: Install macOS development tools
        install_unix_packages_macos  # Step 2: Install packages using Homebrew

    else
        log_message "${ERROR}" "Unsupported OS detected."
        exit 1
    fi
}

#=======================================================================
# Main Function
#=======================================================================

install_unix_packages
