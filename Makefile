SHELL = /bin/sh

#================================================================
# Usage
#================================================================
# make deps		# just install the dependencies
# make install		# perform the end-to-end install
# make clean		# perform a housekeeping cleanup

#=======================================================================
# Variables
#=======================================================================
.EXPORT_ALL_VARIABLES:

# load variables from separate file
include src/make/variables.mk # load variables from a separate makefile file

# path to the directory containing setup scripts
SETUP_SCRIPTS_DIR := src/sh/setup_scripts

#=======================================================================
# Targets
#=======================================================================
all: deps install clean

# To find this the value for the PATH variable, run $(python3 -m site --user-base)/bin
deps:
	@echo "${INFO}\nCalled makefile target 'deps'. Download and install required libraries and dependencies.${COLOUR_OFF}\n"
	@echo "${DEBUG_DETAILS} - Prerequisite: Add Python user binary path to PATH, e.g.: /Users/paulfry/Library/Python/3.9/bin"
	@echo "${DEBUG_DETAILS} - E.g., command to run: export PATH=\$$PATH:\$$HOME/Library/Python/3.9/bin"
	@bash src/sh/setup_scripts/ohmyzsh/install_ohmyzsh.sh
	@bash src/sh/setup_scripts/setup_environment_variables.sh

install:
	@echo "${INFO}\nStep 1: Install Unix packages${COLOUR_OFF}" && bash $(SETUP_SCRIPTS_DIR)/install_unix_packages.sh
	@echo "${INFO}\nStep 2: Install Python and pip${COLOUR_OFF}" && bash $(SETUP_SCRIPTS_DIR)/install_python_and_pip.sh
	@echo "${INFO}\nStep 3: Install Python packages${COLOUR_OFF}" && bash $(SETUP_SCRIPTS_DIR)/install_python_packages.sh
	@echo "${INFO}\nStep 4: Configure development tools${COLOUR_OFF}" && bash $(SETUP_SCRIPTS_DIR)/configure_dev_tools.sh

run:
	@echo "${INFO}\nCalled makefile target 'run'. Launch service.${COLOUR_OFF}"

test:
	@echo "${INFO}\nCalled makefile target 'test'. Perform any required tests.${COLOUR_OFF}"

clean:
	@echo "${INFO}\nCalled makefile target 'clean'. Restoring the repository to its initial state.${COLOUR_OFF}"
	@bash src/sh/setup_scripts/ohmyzsh/cleanup_ohmyzsh.sh
	@sudo rm -rf ~/.vscode/extensions

ohmyzsh:
	@echo "${INFO}\nCalled makefile target 'ohmyzsh'. Download and install 'ohmyzsh'.${COLOUR_OFF}"
	@bash src/sh/setup_scripts/ohmyzsh/install_ohmyzsh.sh

# Phony targets
.PHONY: all deps install run test clean

# .PHONY tells Make that these targets don't represent files
# This prevents conflicts with any files named "all" or "clean"
