#!/bin/bash

# Función para comprobar si el usuario actual es root y cambiar a un usuario no root
check_and_switch_user() {
    if [ "$(id -u)" -eq 0 ]; then
        # El usuario actual es root, cambiamos al usuario no root
        if [ -z "$SUDO_USER" ]; then
            # Si SUDO_USER no está definido, utilizamos el usuario actual
            TARGET_USER="$USER"
        else
            # Utilizamos el valor de SUDO_USER para cambiar al usuario no root
            TARGET_USER="$SUDO_USER"
        fi

        # Cambiamos al usuario no root y mostramos un mensaje
        su - "$TARGET_USER"
        echo "Cambiado al usuario no root: $TARGET_USER"
        exit 0  # Salimos del script
    fi
}

# Install p10k for your user
install_p10k() {
    echo -e "\n${GREEN}${BOLD}Config p10k to zsh to user:${WHITE} $USER ${NONE}"
    
    # Verificar si el directorio de Powerlevel10k ya existe
    if [ -d "$HOME/powerlevel10k" ]; then
        echo -e "Powerlevel10k ya está instalado para el usuario: ${WHITE}$USER${NONE} en $HOME/powerlevel10k. ✅"
        return 0  # Salir sin hacer nada adicional
    fi

    # Download p10k
    echo -e "\n${GREEN}${BOLD}Descargando Powerlevel10k...${NONE}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

    # Verificar si la clonación fue exitosa
    if [ $? -eq 0 ]; then
        echo -e "Powerlevel10k se ha descargado correctamente."
        echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
        zsh
        # Validar la instalación (puedes agregar comandos adicionales aquí si es necesario)
        if [ -d "$HOME/powerlevel10k" ]; then
            echo -e "Powerlevel10k se ha instalado correctamente para el usuario: ${WHITE}$USER${NONE} en $HOME/powerlevel10k. ✅"
        else
            echo -e "❌ Error: No se pudo instalar Powerlevel10k"
        fi
    else
        echo -e "❌ Error: La clonación de Powerlevel10k falló."
    fi
}

install_p10k_user_root() {
    echo -e "\n${GREEN}${BOLD}Config p10k to zsh to user:${RED} root ${NONE}"

    # Verificar si el directorio de Powerlevel10k ya existe
    local p10k=$(sudo sh -c 'cd ~root && ls | grep -w "powerlevel10k"')
    if [ "$p10k" = "powerlevel10k" ]; then
        echo -e "Powerlevel10k ya está instalado para el usuario: ${WHITE}root${NONE} en /root/powerlevel10k. ✅"
        return 0  # Salir sin hacer nada adicional
    fi

    # Ejecutar comandos como root sin cambiar permanentemente al usuario root
    sudo sh -c '
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/powerlevel10k &&
        echo "source /root/powerlevel10k/powerlevel10k.zsh-theme" >> /root/.zshrc &&
        zsh
    '
}
