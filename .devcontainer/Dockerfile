# Base Python 3.10 devcontainer image
FROM mcr.microsoft.com/devcontainers/python:3.10

# Avoid interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Install zsh and prerequisites
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends zsh git curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install oh-my-zsh (unattended) for the 'vscode' user
USER vscode
ENV ZSH="/home/vscode/.oh-my-zsh"
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Minimal .zshrc with a sensible theme & plugins
# (git & vscode terminal integration; add more plugins if you like)
RUN printf '%s\n' \
    'export ZSH="$HOME/.oh-my-zsh"' \
    'ZSH_THEME="robbyrussell"' \
    'plugins=(git)' \
    'source $ZSH/oh-my-zsh.sh' \
    '' \
    '# Make Python venv (if present) first on PATH' \
    'if [ -d "$PWD/.venv/bin" ]; then export PATH="$PWD/.venv/bin:$PATH"; fi' \
    '' \
    '# Colorful, useful defaults' \
    'export EDITOR="code -w"' \
    'export PROMPT_DIRTRIM=3' \
    > /home/vscode/.zshrc

# Make zsh the default shell for 'vscode'
RUN sudo chsh -s /usr/bin/zsh vscode
