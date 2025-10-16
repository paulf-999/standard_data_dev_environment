# dbt Dev Container — Overview

This Dev Container provides a consistent, reproducible environment for working on the dbt repo, with Python 3.10, zsh/oh-my-zsh, and a curated set of VS Code extensions.

---

## What’s included

**Base image**

- `mcr.microsoft.com/devcontainers/python:3.10`

**Shell**

- Default shell: `zsh`
- oh-my-zsh installed (theme: `robbyrussell`, plugins: `git`)
- `.zshrc` adds the project `.venv/bin` to `PATH` when present

**VS Code customisations**

- Default interpreter path: `${workspaceFolder}/.venv/bin/python`
- Auto-activation in terminal disabled (container uses zsh by default)
- Extensions preinstalled:
  - Python: `ms-python.python`, `ms-python.vscode-pylance`, `charliermarsh.ruff`
  - dbt/SQL: `innoverio.vscode-dbt-power-user`, `sqlfluff.vscode-sqlfluff`
  - YAML/templating/markdown: `redhat.vscode-yaml`, `samuelcolvin.jinjahtml`, `davidanson.vscode-markdownlint`
  - Formatting/QoL: `esbenp.prettier-vscode`, `mohsen1.prettify-json`, `pkief.material-icon-theme`, `christian-kohler.path-intellisense`, `aaron-bond.better-comments`, `wayou.vscode-todo-highlight`
  - Data files: `mechatroner.rainbow-csv`, `grapecity.gc-excelviewer`
  - Docker/containers: `ms-azuretools.vscode-docker`, `ms-vscode-remote.remote-containers`

**User & workspace**

- VS Code user: `vscode`
- Workspace folder: `/workspaces/${localWorkspaceFolderBasename}`

---

## Files in this folder

- **`devcontainer.json`** — Dev Containers configuration (image, extensions, VS Code settings).
- **`Dockerfile`** — Adds `zsh` and installs **oh-my-zsh** non-interactively for user `vscode`.

---

## How to use

1. Ensure **Docker Desktop** is installed and running.
2. In VS Code, install the **Dev Containers** extension (by Microsoft).
3. Open the repo and, when prompted, click **Reopen in Container**.
   - If no prompt appears: `Ctrl+Shift+P` / `Cmd+Shift+P` → **Dev Containers: Reopen in Container**.
4. (Optional) Create/prepare a project virtualenv:

    ```bash
    python -m venv .venv
    source .venv/bin/activate
    pip install -r requirements.txt
    ```

5. Run dbt as usual:

    ```bash
    dbt debug
    dbt run
    dbt test
    ```
