#!/bin/bash

#=======================================================================
# Function Name: install_unix_packages
# Description: Installs Python & Pip for differing Unix OSs.
#=======================================================================

# Source shell_utils.sh relative to this script
source "${SHELL_UTILS_PATH}"

#=======================================================================
# Helper Functions
#=======================================================================

# Function to install Python and pip
install_python_and_pip() {

    # Check the OS type
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Check for apt-get (Ubuntu/Debian)
        if command -v apt-get &>/dev/null; then
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip || {
                log_message "${ERROR}" "Failed to install Python or pip using apt-get."
                exit 1
            }
        # Check for yum (CentOS/Fedora)
        elif command -v yum &>/dev/null; then
            sudo yum install -y python3 python3-pip || {
                log_message "${ERROR}" "Failed to install Python or pip using yum."
                exit 1
            }
        # Check for dnf (Fedora)
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y python3 python3-pip || {
                log_message "${ERROR}" "Failed to install Python or pip using dnf."
                exit 1
            }
        else
            log_message "${ERROR}" "No suitable package manager found (apt-get, yum, or dnf)."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS: Check if Python 3 is already installed
        if command -v python3 &>/dev/null; then
            log_message "${DEBUG_DETAILS}" "Python3 is already installed on macOS - skipping installation."
        else
            # macOS uses Homebrew to install Python if not already installed
            brew install python || {
                log_message "${ERROR}" "Failed to install Python or pip using Homebrew."
                exit 1
            }
        fi

        # Check if pip3 is installed (for Python 3)
        if ! command -v pip3 &>/dev/null; then
            log_message "${DEBUG_DETAILS}" "pip3 not found, installing pip3."
            # Install pip3 for Python 3
            curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
            sudo python3 get-pip.py || {
                log_message "${ERROR}" "Failed to install pip3."
                exit 1
            }
            rm get-pip.py
        else
            log_message "${DEBUG_DETAILS}" "pip3 is already installed - skipping installation."
        fi
    else
        log_message "${ERROR}" "Unsupported OS detected for Python and pip installation."
        exit 1
    fi
}

#=======================================================================
# Main Function
#=======================================================================

install_python_and_pip
