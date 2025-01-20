#!/bin/bash

EXTENSIONS_PYTHON=(
    "demystifying-javascript.python-extensions-pack"  # Python Extension Pack
    "charliermarsh.ruff"  # Ruff for linting and formatting
    "ms-python.isort"  # isort for sorting imports
)

EXTENSIONS_DATA_TOOLING=(
    "hashicorp.terraform"
    "innoverio.vscode-dbt-power-user"
    "dorzey.vscode-sqlfluff"
    # Docker extensions
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
