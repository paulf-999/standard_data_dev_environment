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
include src/scripts/other/variables.mk # load variables from a separate makefile file

CONFIG_FILE := config.yaml

#=======================================================================
# Targets
#=======================================================================
all: deps install clean

deps:
	@echo "${INFO}\nCalled makefile target 'deps'. Download and install required libraries and dependencies.${COLOUR_OFF}"
	@bash src/setup/setup_environment.sh

install:
	@echo "${INFO}\nCalled makefile target 'install'. Run the setup & install targets.${COLOUR_OFF}"

run:
	@echo "${INFO}\nCalled makefile target 'run'. Launch service.${COLOUR_OFF}"

test:
	@echo "${INFO}\nCalled makefile target 'test'. Perform any required tests.${COLOUR_OFF}"

clean:
	@echo "${INFO}\nCalled makefile target 'clean'. Restoring the repository to its initial state.${COLOUR_OFF}"
	@bash src/setup/configure_tools/ohmyzsh/cleanup_ohmyzsh.sh
	@rm -rf ~/.vscode/extensions


ohmyzsh:
	@echo "${INFO}\nCalled makefile target 'ohmyzsh'. Download and install required libraries and dependencies.${COLOUR_OFF}"
	@bash src/setup/configure_tools/ohmyzsh/configure_ohmyzsh.sh

# Phony targets
.PHONY: all deps install run test clean

# .PHONY tells Make that these targets don't represent files
# This prevents conflicts with any files named "all" or "clean"
