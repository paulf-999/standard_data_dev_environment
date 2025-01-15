#!/bin/bash

#=======================================================================
# Variables
#=======================================================================

# Get the directory of the current script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Source shell_utils.sh relative to this script
source "${SCRIPT_DIR}/../../scripts/sh/shell_utils.sh"
source "${SCRIPT_DIR}/vscode_extensions_list.sh"

# Array of extension categories and their corresponding extensions
declare -A EXTENSIONS_CATEGORIES=(
    ["Python"]="EXTENSIONS_PYTHON"
    ["Data-Tooling"]="EXTENSIONS_DATA_TOOLING"
    ["Formatting"]="EXTENSIONS_FORMATTING"
    ["Miscellaneous"]="EXTENSIONS_MISC"
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

# Copy settings.json.template to settings.json
configure_vscode_settings_json() {
    # Define the source and destination for settings.json
    TEMPLATE_FILE="${SCRIPT_DIR}/settings.json.template"
    DEST_FILE="${HOME}/.config/Code/User/settings.json"  # Adjust this path if needed

    # Copy the template directly to settings.json
    cp "$TEMPLATE_FILE" "$DEST_FILE" || {
        print_error_message "Error: Failed to copy settings.json.template to $DEST_FILE."
        exit 1
    }

    log_message "${INFO}" "settings.json has been created at $DEST_FILE."
}

#=======================================================================
# Main Script Logic
#=======================================================================

# Loop through the categories and install extensions
for category in "${!EXTENSIONS_CATEGORIES[@]}"; do
    # Retrieve the array of extensions for the category
    extensions_array="${EXTENSIONS_CATEGORIES[$category]}"
    
    # Log the message for each category
    log_message "${DEBUG}" "Installing ${category} extensions"
    
    # Call the install_extensions function with the appropriate array
    install_extensions "${!extensions_array[@]}"
done

log_message "${DEBUG}" "Uninstalling Python extensions"
uninstall_extensions "${EXTENSIONS_TO_UNINSTALL[@]}" && echo

# Configure settings.json
configure_settings_json
