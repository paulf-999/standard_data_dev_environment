#!/bin/bash

#=======================================================================
# Function Name: install_unix_packages
# Description: Installs Unix packages listed in unix_packages.txt
#              while skipping certain packages for macOS.
#=======================================================================

#=======================================================================
# Variables
#=======================================================================

# Inputs
ROOT_DIR=$(pwd)
IP_CONFIG_DIR="${ROOT_DIR}/config"

# Source shell_utils.sh relative to this script
source "${ROOT_DIR}/src/sh/shell_utils.sh"

UNIX_PACKAGES_TXT_PATH="${IP_CONFIG_DIR}/tools/unix_packages.txt"

#=======================================================================
# Functions
#=======================================================================

# Function to install Unix packages
install_unix_packages_linux() {

    # Update Unix packages
    log_message "${DEBUG_DETAILS}" "Updating Unix package list..."
    sudo apt-get -yqq update || {
        log_message "${ERROR}" "Failed to update Unix packages."
        exit 1
    }

    # log_message "${DEBUG_DETAILS}" "Installing Unix packages..."
    sudo apt -yqq install "$(cat "${UNIX_PACKAGES_TXT_PATH}")" || {
        log_message "${ERROR}" "Failed to install Unix packages via apt."
        exit 1
    }
}

# Function to install packages on macOS using Homebrew
install_unix_packages_macos() {

    log_message "${DEBUG}" "i. Prerequisite step: update Homebrew\n"
    brew update > /dev/null # Ensure Homebrew is up-to-date

    # Install development tools for macOS
    log_message "${DEBUG}" "ii. Installing macOS dev tools using Homebrew"
    brew install gcc make > /dev/null 2>&1 || {
        log_message "${ERROR}" "Failed to install macOS development tools."
        exit 1
    }

    # List of packages to skip on macOS
    MAC_OS_SKIP_PACKAGES=("build-essential" "openjdk-11-jre" "ruby-full" "wslu")

    # Install other packages listed in the unix_packages.txt (excluding those in ${MAC_OS_SKIP_PACKAGES})
    log_message "${DEBUG}" "iii. Install unix packages listed in ${UNIX_PACKAGES_TXT_PATH}"
    while read -r package; do
        # Check if the package is in the ${MAC_OS_SKIP_PACKAGES} array
        package_found=false
        for skip_package in "${MAC_OS_SKIP_PACKAGES[@]}"; do
            if [[ "$skip_package" == "$package" ]]; then
                package_found=true
                break
            fi
        done

        if [[ "$package_found" == true ]]; then
            # log_message "${DEBUG}" "Skipping installation of $package."
            continue  # Skip the problematic package
        fi

        # log_message "${DEBUG_DETAILS}" "Installing package: $package"
        if ! brew install "$package" > /dev/null 2>&1; then
            log_message "${ERROR}" "Failed to install package: $package via Homebrew."
            exit 1
        fi

    done < "${UNIX_PACKAGES_TXT_PATH}"
}

# Function to install Unix packages (Master function)
install_unix_packages() {

    # Check for OS and use appropriate package manager
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        log_message "${DEBUG_DETAILS}" "- Operating System: Linux"
        log_message "${DEBUG_DETAILS}" "- Note: You will be prompted for your sudo password during package installation."
        install_unix_packages_linux  # Step 2: Install packages using apt

    elif [[ "$OSTYPE" == "darwin"* ]]; then
        log_message "${DEBUG_DETAILS}" "- Operating System: Mac"
        log_message "${DEBUG_DETAILS}" "- Note: You will be prompted for your sudo password during package installation."
        install_unix_packages_macos  # Step 2: Install packages using Homebrew

    else
        log_message "${ERROR}" "Unsupported OS detected."
        exit 1
    fi
}

#=======================================================================
# Ensure VS Code 'code' CLI is in PATH (macOS & Linux)
#=======================================================================

ensure_vscode_cli_in_path() {
  log_message "${DEBUG_DETAILS}" "Ensuring VS Code 'code' CLI is in PATH..."

  if command -v code &>/dev/null; then
    log_message "${INFO}" "'code' CLI is already in PATH."
    return
  fi

  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS default path for VS Code CLI
    VSCODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
    if [ -f "$VSCODE_BIN" ]; then
      ln -sf "$VSCODE_BIN" "/usr/local/bin/code"
      log_message "${INFO}" "Symlinked VS Code CLI to /usr/local/bin/code"
    else
      log_message "${ERROR}" "VS Code CLI binary not found at expected location: $VSCODE_BIN"
      exit 1
    fi

  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Check common install locations for VS Code
    if [ -f "/usr/bin/code" ]; then
      log_message "${INFO}" "'code' CLI exists at /usr/bin/code but not in PATH — check your shell config."
    elif [ -f "/usr/local/bin/code" ]; then
      log_message "${INFO}" "'code' CLI exists at /usr/local/bin/code but not in PATH — check your shell config."
    else
      log_message "${ERROR}" "'code' CLI not found. Did you install VS Code?"
      exit 1
    fi
  else
    log_message "${ERROR}" "Unsupported OS for VS Code CLI setup."
    exit 1
  fi

  # Confirm it's now accessible
  if ! command -v code &>/dev/null; then
    log_message "${ERROR}" "'code' CLI still not in PATH. Please add it manually."
    exit 1
  fi

  log_message "${INFO}" "'code' CLI is now available in PATH."
}

#=======================================================================
# Main Function
#=======================================================================

install_unix_packages

# Ensure VS Code CLI is available for later scripts
ensure_vscode_cli_in_path

log_message "${INFO}" "Unix package installation complete!\n"
