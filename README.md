# Standard Data Dev Environment

This repository contains automation scripts intended to set up a standardised developer environments for data tools on Linux systems.

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

| **Tool/Technology**              | **Category**        | **Description**                                                      |
| -------------------------------- | ------------------- | -------------------------------------------------------------------- |
| **Environment Variables**        | Core Setup          | Configures environment variables across shells (Bash, Zsh, etc.).    |
| **Unix Packages**                | Core Setup          | Installs baseline CLI tools (see `config/tools/unix_packages.txt`).  |
| **Python & Pip**                 | Core Setup          | Installs Python and `pip` for managing packages.                     |
| **Python Packages**              | Core Setup          | Installs essentials from `requirements.txt`, including `ruff`.       |
| **Zsh & Oh My Zsh**              | Core Setup / Config | Zsh shell plus Oh My Zsh for managing shell configurations.          |
| **VSCode Extensions** | Tool Config         | Installs standard extensions and applies a standard `settings.json`. |
| **SQLFluff**                     | Tool                | Lints SQL files to enforce style and quality.                        |

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

| **Step**                         | **Description**                                                                              |
| -------------------------------- | -------------------------------------------------------------------------------------------- |
| **Baseline Unix Packages**       | Installs essential CLI tools (see `config/tools/unix_packages.txt`).                         |
| **Python & Pip**                 | Installs Python and `pip`.                                                                   |
| **Python Packages**              | Installs packages from `requirements.txt` — includes `ruff` for Python linting & formatting. |
| **VSCode Extensions & Settings** | Installs standard extensions and applies the `settings.json` template.                       |
| **SQLFluff**                     | Lints SQL files for consistent style.                                                        |
</details><br/>

By following these steps, you'll have a Unix-based development environment ready to use, empowering you to work seamlessly with a variety of data tools originally designed for Linux systems.
