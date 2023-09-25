#!/bin/bash

# Define colors
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'

readonly REPO_DIR="$(dirname "$(readlink -m "${0}")")"
readonly RELEASE_DIR="${REPO_DIR}/release"
source "${REPO_DIR}/shell/config_tools.sh"
source "${REPO_DIR}/shell/config_fonts.sh"

# !------------ Define flow to configuration --------------!
# Install the tools required
echo -e "\n${GREEN}${BOLD}Installing required tools:${NONE}"
install_tools "${tools_requirements[@]}"

# Install the tools
echo -e "\n${GREEN}${BOLD}Installing tools:${NONE}"
install_tools "${tools_to_install[@]}"

echo -e "\n${GREEN}${BOLD}Installing Hack Nerd Font:${NONE}"
install_hack_nerd_font

# !------------ final status review of installed tools  --------------!
# Validate the installation of the tools requeriments
echo -e "\n${GREEN}${BOLD}FINAL REVIEW${NONE}"
all_tools=("${tools_requirements[@]}" "${tools_to_install[@]}") # Unir las dos listas
for tool in "${all_tools[@]}"; do
    validate_installation "$tool"
done
