# Standard Data Dev Environment

This repository contains automation scripts intended to set up and enhance developers' environments for data tools on Linux systems.

---

## Background

* Many standard data tools are designed for Linux systems.
* This repo contains a variety of scripts to automate the setup of data tools/technologies on Linux.

## Installation

To set up your development environment, follow these steps:

1. **Install Dependencies**: Run the following command to install the necessary dependencies:

    ```bash
    make deps
    ```

2. **Install the Setup**: After the dependencies are installed, run the following command to complete the environment setup:

    ```bash
    make install
    ```

### What is Being Installed?

The following tools and technologies will be installed and configured during the setup:


| **Tool/Technology**      | **Category**          | **Description**                                                                 |
|--------------------------|-----------------------|---------------------------------------------------------------------------------|
| **Environment Variables** | **Core Setup**        | Configuration for environment variables across shell configurations (Bash, Zsh, etc.). |
| **Unix Packages**         | **Core Setup**        | Baseline tools and utilities required for your development environment (see `config/tools/unix_packages.txt`). |
| **Python & Pip**          | **Core Setup**        | Python and `pip` for managing Python packages.                                   |
| **Python Packages**       | **Core Setup**        | A set of essential Python packages (see `requirements.txt`).                     |
| **Zsh**                   | **Core Setup**        | A shell for your development environment.                                       |
| **Oh My Zsh**             | **Tool Configuration**       | A framework for managing Zsh configurations.                                     |
| **VSCode Extensions**     | **Tool Configuration**              | A suite of extensions for enhancing the VSCode editor (see `src/sh/setup_scripts/vscode/configure_vscode.sh`). |
| **VSCode `settings.json`**       | **Tool Configuration**              | A standard `settings.json` for VSCode (see `config/templates/settings.json.template`). |
| **SQLFluff**              | **Tool**              | A tool for linting SQL files to ensure code quality.                             |

### Background : What are the Commands `make deps` & `make install` Doing?

#### `make deps`

<details>
<summary>Expand for detailed instructions</summary>

Running `make deps` will automatically:

| **Step**                        | **Description**                                                              |
|----------------------------------|------------------------------------------------------------------------------|
| **Install Zsh**                  | Installs Zsh, the shell used for your environment.                           |
| **Install Oh My Zsh**            | Installs the `Oh My Zsh` framework to enhance the Zsh shell experience.      |
| **Set Up Environment Variables** | Configures the necessary environment variables across different shell configurations (e.g., Bash, Zsh). |

</details>

#### `make install`

<details>
<summary>Expand for detailed instructions</summary>

After running `make deps`, you need to run `make install` to complete the installation:

Running `make install` executes `src/sh/setup_environment.sh`, which performs the following:

| **Step**                            | **Description**                                                                                                                                               |
|-------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Installs Baseline Unix Packages** | Installs essential Unix packages (as listed in `config/tools/unix_packages.txt`).                                                                              |
| **Installs Python & Pip**           | Installs Python and `pip` to manage Python packages.                                                                                                          |
| **Installs Python Packages**        | Installs a suite of Python packages listed in `requirements.txt` at the root of the repository.                                                               |
| **Installs VSCode Extensions**     | Installs a suite of VSCode extensions (as detailed in `src/sh/setup_scripts/vscode/configure_vscode.sh`) and applies a standard `settings.json` file.         |
| **Installs SQLFluff**               | Installs the SQLFluff package for linting SQL files.                                                                                                          |

</details><br/>

By following these steps, you'll have a Unix-based development environment ready to use, empowering you to work seamlessly with a variety of data tools originally designed for Linux systems.
