#!/bin/bash

# Inputs
ROOT_DIR=$(pwd)

# Source shell_utils.sh relative to this script
source "${ROOT_DIR}/src/sh/shell_utils.sh"

#=======================================================================
# Helper Functions
#=======================================================================


# Configure development tools
configure_dev_tools() {

    # Install VSCode extensions
    log_message "${DEBUG}" "- 4.1. Install VSCode extensions"
    bash "${SETUP_SCRIPTS_DIR}"/vscode/configure_vscode.sh || {
        log_message "${ERROR}" "Error: Failed to configure Visual Studio Code."
        exit 1
    }

    # Configure SQLFluff using jinja2 template
    log_message "${DEBUG}" "4.2. Configure SQLFluff"
    # To avoid any potential issue, we'll update the PATH for the current shell session
    export PATH="${PATH}:${LOCAL_BIN_PATH}:${PYTHON_BIN_PATH}"
    j2 "${TEMPLATES_DIR}"/.sqlfluff_template.j2 -o ~/.sqlfluff || {
        log_message "${ERROR}" "Error: Failed to configure SQLFluff."
        exit 1
    }
}

#=======================================================================
# Main Script Logic
#=======================================================================

configure_dev_tools
