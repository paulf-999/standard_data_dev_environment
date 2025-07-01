#!/bin/bash

# Source shell_utils.sh relative to this script
source src/sh/shell_utils.sh

# Detect operating system
OS_TYPE=$(uname -s)

#=======================================================================
# Functions
#=======================================================================
check_homebrew() {
    if [[ "${OS_TYPE}" == "Darwin" ]] && ! command -v brew &>/dev/null; then
        log_message "${DEBUG_DETAILS}" "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

install_zsh() {
    # log_message "${DEBUG}" "# i: Install zsh"
    if [[ "${OS_TYPE}" == "Darwin" ]]; then
        if ! command -v zsh &>/dev/null; then
            log_message "${DEBUG_DETAILS}" "Installing zsh using Homebrew..."
            brew install zsh
        # else
        #    log_message "${DEBUG_DETAILS}" "zsh is already installed."
        fi
    elif [[ "${OS_TYPE}" == "Linux" ]]; then
        sudo apt install -yqq zsh zsh-common zsh-doc
    else
        log_message "${DEBUG_DETAILS}" "Unsupported operating system: ${OS_TYPE}"
        exit 1
    fi
}

install_ohmyzsh() {
    # log_message "${DEBUG}" "# ii: Install 'Oh My Zsh'"
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        log_message "${DEBUG_DETAILS}" "'Oh My Zsh' is already installed."
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1 &
        wait
    fi
}

install_ohmyzsh_plugins() {
    # log_message "${DEBUG}" "# iii: Install the 'Oh My Zsh' plugins"

    local ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    # zsh-syntax-highlighting
    if [[ ! -d "${ZSH_CUSTOM_DIR}/zsh-syntax-highlighting" ]]; then
        git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM_DIR}/zsh-syntax-highlighting"
    fi

    # zsh-completions
    if [[ ! -d "${ZSH_CUSTOM_DIR}/zsh-completions" ]]; then
        git clone -q https://github.com/zsh-users/zsh-completions.git "${ZSH_CUSTOM_DIR}/zsh-completions"
    fi

    # zsh-autosuggestions
    if [[ ! -d "${ZSH_CUSTOM_DIR}/zsh-autosuggestions" ]]; then
        git clone -q https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM_DIR}/zsh-autosuggestions"
    fi

    wait

    # Define zshrc variable here so it's available for the plugin update
    local zshrc="${HOME}/.zshrc"

    if [[ -f "$zshrc" ]]; then
        sed -i.bak '/^plugins=(git)$/c\
plugins=(\
    git\
    zsh-syntax-highlighting\
    zsh-autosuggestions\
    zsh-completions\
)\
# command for zsh-completions\
autoload -U compinit && compinit' "$zshrc"

        # log_message "${DEBUG_DETAILS}" "Plugins successfully installed and added to .zshrc!"
    else
        log_message "${DEBUG_DETAILS}" ".zshrc not found! Unable to update plugins."
    fi
}

install_powerlevel10k() {
    # log_message "${DEBUG}" "# iv: Install Powerlevel10k theme"
    local theme_dir="$HOME/.oh-my-zsh/themes/powerlevel10k"
    local zshrc="${HOME}/.zshrc"

    if [[ -d "$theme_dir" ]]; then
        log_message "${DEBUG_DETAILS}" "ZSH Theme 'Powerlevel10k' is already installed."
    else
        git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir" || log_message "${DEBUG_DETAILS}" "Failed to clone Powerlevel10k theme. Please check your internet connection."
    fi

    # Check if .zshrc exists, create it if missing
    if [[ ! -f "$zshrc" ]]; then
        log_message "${DEBUG_DETAILS}" ".zshrc not found, creating a new one."
        touch "$zshrc"
    fi

    # Set ZSH_THEME to Powerlevel10k in .zshrc
    if [[ -f "$zshrc" ]]; then
        sed -i.bak -E "s/^ZSH_THEME=.*$/ZSH_THEME=\"powerlevel10k\/powerlevel10k\"/" "$zshrc"
    else
        log_message "${DEBUG_DETAILS}" ".zshrc not found! Unable to set Powerlevel10k theme."
    fi

    exec zsh -c '. ~/.oh-my-zsh/themes/powerlevel10k/powerlevel10k.zsh-theme'
}

finalise_zsh_setup() {
    # log_message "${DEBUG}" "# v: Finalise the zsh setup"

    # Ensure the PATH is correctly set in .zshrc
    echo "export PATH=/usr/local/bin:$PATH" >> ~/.zshrc
    echo "export PATH=/usr/local/bin:$PATH" >> ~/.zshrc

    # Source the .zshrc file to apply the changes
    if source ~/.zshrc; then
        log_message "${DEBUG_DETAILS}" ".zshrc has been successfully sourced."
    else
        log_message "${DEBUG_DETAILS}" "Error: Failed to source .zshrc."
    fi
}

# Install Zsh and setup environment variables
log_message "${DEBUG}" "# Step 1: Install Zsh and Oh My Zsh"
install_zsh
install_ohmyzsh
install_ohmyzsh_plugins
install_powerlevel10k
finalise_zsh_setup

# Call the setup_environment_variables script to ensure PATH is updated
setup_environment_variables
