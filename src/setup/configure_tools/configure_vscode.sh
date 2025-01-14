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
    "ms-python.flake8"
    "ms-python.isort"
)

EXTENSIONS_DATA_TOOLING=(
    "hashicorp.terraform"
    "innoverio.vscode-dbt-power-user"
    "dorzey.vscode-sqlfluff"
    # Docker extns
    "ms-azuretools.vscode-docker"
    "ms-vscode-remote.remote-containers"
    "ms-toolsai.datawrangler"
    "mtxr.sqltools"
    "postman.postman-for-vscode"
)

# Extensions for Markdown, Jinja, and related formats
EXTENSIONS_FORMATTING=(
    "samuelcolvin.jinjahtml"
    "davidanson.vscode-markdownlint"
    "esbenp.prettier-vscode"
    "mohsen1.prettify-json"
    "wayou.vscode-todo-highlight"
    "davidanson.vscode-markdownlint"
)

# Additional Extensions
EXTENSIONS_MISC=(
    "github.copilot"
    "aaron-bond.better-comments"
    "codezombiech.gitignore"
    "samuelcolvin.jinjahtml"
    "christian-kohler.path-intellisense"
    "redhat.vscode-yaml"
    "pkief.material-icon-theme"
    "mechatroner.rainbow-csv"
    "grapecity.gc-excelviewer"
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
    "sourcery.sourcery"
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

log_message "${DEBUG}" "Installing Data-Tooling-related extensions"
install_extensions "${EXTENSIONS_DATA_TOOLING[@]}"

log_message "${DEBUG}" "Installing Formatting-related extensions"
install_extensions "${EXTENSIONS_FORMATTING[@]}"

log_message "${DEBUG}" "Installing miscellaneous extensions"
install_extensions "${EXTENSIONS_MISC[@]}"

log_message "${DEBUG}" "Uninstalling Python extensions"
uninstall_extensions "${EXTENSIONS_TO_UNINSTALL[@]}" && echo
