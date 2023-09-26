#!/bin/bash

readonly REPO_DIR="$(dirname "$(readlink -m "${0}")")"
readonly RELEASE_DIR="${REPO_DIR}/release"
source "${REPO_DIR}/shell/vars.sh"
source "${REPO_DIR}/shell/config_tools.sh"
source "${REPO_DIR}/shell/config_fonts.sh"

#update system
echo -e "\n${GREEN}${BOLD}Update and upgrade your system :${NONE}"
update_system

# Animation initialization
matrix() {
    install_tools cmatrix
    sudo $package_manager install cmatrix
    clear
    cmatrix & # Inicia cmatrix en segundo plano
    sleep 2.5
    pkill cmatrix # Termina el proceso de cmatrix
}
matrix

# Menú para que el usuario elija entre las opciones 1 o 2
echo -e "\n${GREEN}${BOLD}Selecciona una opción:${NONE}"
echo -e "${WHITE}[1]${NONE} Install basic tools of a linux environment"
echo -e "${WHITE}[2]${NONE} Install zsh environment to terminal with · p10k · Nerd Fonts · lsd · oh my tmux "
read -n 1 option

# Verificar la opción seleccionada
case $option in
    1)
        # Install the tools required
        echo -e "\n${GREEN}${BOLD}Installing required tools:${NONE}"
        install_tools "${TOOLS_REQUIREMENTS[@]}"
        # Install the tools
        echo -e "\n${GREEN}${BOLD}Installing tools:${NONE}"
        install_tools "${TOOLS_TO_INSTALL[@]}"

        # Install docker and plugins
        echo -e "\n${GREEN}${BOLD}Installing docker and plugins...${NONE}"
        install_docker

        # Install docker and plugins
        echo -e "\n${GREEN}${BOLD}Installing docker-compose:${NONE}"
        install_docker_compose

        # check the status of the final installation of the tools
        echo -e "\n${GREEN}${BOLD}FINAL REVIEW${NONE}"
        all_tools=("${TOOLS_REQUIREMENTS[@]}" "${TOOLS_TO_INSTALL[@]}" "${TOOLS_TO_DOCKER[@]}" docker-compose docker)
        for tool in "${all_tools[@]}"; do
            validate_installation_tools "$tool"
        done
        ;;

    2)
        # Install the tools required
        echo -e "\n${GREEN}${BOLD}Installing required tools:${NONE}"
        install_tools "${TOOLS_REQUIREMENTS_P10K[@]}"
        # Instalar Hack Nerd Font y configurar la fuente en la terminal
        echo -e "\n${GREEN}${BOLD}Installing Hack Nerd Font:${NONE}"
        install_hack_nerd_font

        echo -e "\n${GREEN}${BOLD}Set ${PURPLE}hack nerd font ${NONE}${GREEN}${BOLD}as default font in terminal.${NONE}"
        set_hack_nerd_font

        # Validate the installation of the tools requeriments
        echo -e "\n${GREEN}${BOLD}FINAL REVIEW${NONE}"
        tools=("${TOOLS_REQUIREMENTS[@]}")
        for tool in "${tools[@]}"; do
            validate_installation_tools "$tool"
        done
        ;;

    *)
        # Opción no válida
        echo -e "\n${GREEN}${BOLD}Opción no válida. No se realizó ninguna acción.${NONE}"
        ;;
esac