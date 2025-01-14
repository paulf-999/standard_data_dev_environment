#!/bin/bash

#=======================================================================
# Variables
#=======================================================================

# Get the directory of the current script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Source shell_utils.sh relative to this script
source "${SCRIPT_DIR}/../../scripts/sh/shell_utils.sh"

# Define Extension Categories
EXTENSIONS_PYTHON=(
    "demystifying-javascript.python-extensions-pack"  # Python Extension Pack
    "ms-python.black-formatter"
    "ms-python.isort"
)

# Terraform Extension Pack
EXTENSIONS_TERRAFORM=(
    "hashicorp.terraform"
    "innoverio.vscode-dbt-power-user"
    "dorzey.vscode-sqlfluff"
)

# Uninstall Extensions by Category
EXTENSIONS_TO_UNINSTALL=(
    # Version Control Extensions
    "donjayamanne.git-extension-pack"
    "eamodio.gitlens"
    "donjayamanne.githistory"

    # Python-related Extensions
    "dongli.python-preview"  # Python Preview
    "batisteo.vscode-django"  # Django (Python Framework)
    "thebarkman.vscode-djaneiro"  # Django (Python Framework specific)
    "kaih2o.python-resource-monitor"

    # Python Test-related Extensions
    "littlefoxteam.vscode-python-test-adapter"  # Python Test Adapter
    "hbenl.vscode-test-explorer"  # Test Explorer

    # Miscellaneous Extensions
    "trabpukcip.wolf"  # Miscellaneous (does not seem to fit into other categories)
    "xirider.livecode"  # Miscellaneous (possibly for live code)
    "alefragnani.project-manager"  # Project Manager (can be linked to version control management)
    "deerawan.vscode-dash"
    "ms-vscode.test-adapter-converter"
)


#=======================================================================
# Functions
#=======================================================================

install_extensions() {
    local extensions=("$@")  # Array of extensions
    for extension in "${extensions[@]}"; do
        code --install-extension "${extension}" --force &>/dev/null && {
            log_message "${INFO}" "Installed extension: ${extension}"
        } || {
            print_error_message "Error: Failed to install VSCode extension: ${extension}"
        }
    done
}

uninstall_extensions() {
    local extensions=("$@")  # Array of extensions
    for extension in "${extensions[@]}"; do
        code --uninstall-extension "${extension}" &>/dev/null && {
            log_message "${INFO}" "Uninstalled extension: ${extension}"
        } || {
            print_error_message "Error: Failed to uninstall VSCode extension: ${extension}"
        }
    done
}

#=======================================================================
# Main Script Logic
#=======================================================================

# Install Extensions by Category (passing arrays directly)
log_message "${DEBUG}" "Installing Python extensions"
install_extensions "${EXTENSIONS_PYTHON[@]}"

log_message "${DEBUG}" "Uninstalling Python extensions"
uninstall_extensions "${EXTENSIONS_TO_UNINSTALL[@]}" && echo