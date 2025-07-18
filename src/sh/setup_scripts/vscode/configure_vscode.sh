#!/bin/bash

# Inputs
ROOT_DIR=$(pwd)
TEMPLATES_DIR="${ROOT_DIR}/config/templates"

# Source shell_utils.sh relative to this script
source "${ROOT_DIR}/src/sh/shell_utils.sh"

source "${SETUP_SCRIPTS_DIR}/vscode/vscode_extensions_list.sh"

# Array of extension categories (used as indices for arrays)
EXTENSIONS_CATEGORIES=("Python" "Data-Tooling" "Formatting" "Miscellaneous")

#=======================================================================
# Functions
#=======================================================================

install_extensions() {
    local extensions=("$@")  # Array of extensions
    for extension in "${extensions[@]}"; do
        code --extensions-dir "${HOME}/.vscode/extensions" --install-extension "${extension}" --force &>/dev/null || {
            print_error_message "Error: Failed to install VSCode extension: ${extension}"
        }
    done
}

uninstall_extensions() {

    log_message "${DEBUG_DETAILS}" "- Uninstalling Python extensions"

    local extensions=("$@")
    for extension in "${extensions[@]}"; do
        if ! code --extensions-dir "${HOME}/.vscode/extensions" --uninstall-extension "${extension}" &>/dev/null; then
            if code --list-extensions | grep -q "${extension}"; then
                print_error_message "Error: Failed to uninstall VSCode extension: ${extension}. Please check if it's installed correctly."
            fi
            # Else: was not installed → do nothing.
        fi
    done
}

# Determine the appropriate settings.json file path based on the OS
get_vscode_settings_path() {
    # Default settings file for Unix-like systems (Linux/macOS)
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "${HOME}/.config/Code/User/settings.json"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "${HOME}/Library/Application Support/Code/User/settings.json"
    # Default settings file for Windows systems
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "${APPDATA}/Code/User/settings.json"
    else
        print_error_message "Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

# Copy settings.json.template to the appropriate settings.json
configure_vscode_settings_json() {
    # Define the absolute path to the settings.json.template based on the root directory
    TEMPLATE_FILE="${TEMPLATES_DIR}/settings.json.template"

    # Debugging: Print the computed template file path to check it
    # echo "Looking for template file at: $TEMPLATE_FILE"

    # Check if the template file exists before proceeding
    if [ ! -f "$TEMPLATE_FILE" ]; then
        print_error_message "Error: settings.json.template not found at $TEMPLATE_FILE."
        exit 1
    fi

    # Determine the destination path based on OS
    DEST_FILE=$(get_vscode_settings_path)

    # Copy the template directly to settings.json
    cp "$TEMPLATE_FILE" "$DEST_FILE" || {
        print_error_message "Error: Failed to copy settings.json.template to $DEST_FILE."
        exit 1
    }

    log_message "${DEBUG}" "settings.json has been created at $DEST_FILE."
}

#=======================================================================
# Main Script Logic
#=======================================================================

if [ "${#EXTENSIONS_TO_UNINSTALL[@]}" -eq 0 ]; then
  log_message "${DEBUG_DETAILS}" "No extensions to uninstall."
else
  uninstall_extensions "${EXTENSIONS_TO_UNINSTALL[@]}"
fi

# Loop through the categories and install extensions
for category in "${EXTENSIONS_CATEGORIES[@]}"; do
    # Log the message for each category
    log_message "${DEBUG_DETAILS}" "- Installing ${category} extensions"

    # Install the extensions based on the category
    if [[ "$category" == "Python" ]]; then
        install_extensions "${EXTENSIONS_PYTHON[@]}"
    elif [[ "$category" == "Data-Tooling" ]]; then
        install_extensions "${EXTENSIONS_DATA_TOOLING[@]}"
    elif [[ "$category" == "Formatting" ]]; then
        install_extensions "${EXTENSIONS_FORMATTING[@]}"
    elif [[ "$category" == "Miscellaneous" ]]; then
        install_extensions "${EXTENSIONS_MISC[@]}"
    fi
done

# Configure settings.json
configure_vscode_settings_json
