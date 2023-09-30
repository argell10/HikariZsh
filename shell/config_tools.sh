############################################
#        Install tools                    #
##########################################

# Animation initialization
matrix() {
    install_tools cmatrix
    sudo $package_manager install cmatrix
    clear
    cmatrix & # Inicia cmatrix en segundo plano
    sleep 2.5
    pkill cmatrix # Termina el proceso de cmatrix
}

# Check the available package manager (apt or yum)
if type "apt" &>/dev/null; then
    package_manager="apt"
elif type "yum" &>/dev/null; then
    package_manager="yum"
else
    echo "❌ No compatible package manager (apt or yum) found."
    exit 1
fi

# Function to install a list of tools
install_tools() {
    local tools=("$@")
    for tool in "${tools[@]}"; do
        if ! type "$tool" &>/dev/null; then
            echo "⚙️ Installing $tool..."
            if [ "$package_manager" = "apt" ]; then
                sudo apt install "$tool" -y >/dev/null 2>&1  # Redirigir salida
            elif [ "$package_manager" = "yum" ]; then
                sudo yum install "$tool" -y >/dev/null 2>&1  # Redirigir salida
            fi
        else
            echo "✅ $tool is already installed."
        fi
    done
}


################################################
#           Validate instalations             #
###############################################

# Function to validate the installation of a tool
validate_installation_tools() {
    local tool="$1"
    if type "$tool" &>/dev/null; then
        echo "✅ $tool installed successfully."
        return 0  # Success
    else
        echo  "❌ Error: Failed to install $tool."
        return 1  # Error
    fi
}

####################################################
#     Config to install dokcer and dokcer-compose #                 
##################################################

# Install docker using the Apt repository docker
install_docker() {
    # Run the following command to uninstall all conflicting packages:
    if command -v docker &>/dev/null; then
        echo "✅ docker ya está instalado en el sistema."
        return 0
    fi
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
        sudo "$package_manager" remove "$pkg" -y >/dev/null 2>&1  # Desinstala silenciosamente
    done

    # Add repositories to apt package docker
    echo -e "\n${GREEN}${BOLD}Add repositories to apt package docker...${NONE}" 

    # Si el archivo de clave GPG no existe, agregarlo
    if [ ! -f "/etc/apt/keyrings/docker.gpg" ]; then
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
    fi

    # Add Docker's official GPG key:
    sudo "$package_manager" install ca-certificates curl gnupg -y >/dev/null 2>&1  # Instala silenciosamente

    # Agregar el repositorio a las fuentes de Apt solo si no existe
    if ! grep -q "docker.list" /etc/apt/sources.list.d/*; then
        echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    fi

    sudo "$package_manager" update >/dev/null 2>&1  # Actualiza silenciosamente

    echo -e "\n${GREEN}${BOLD}Installing docker...${NONE}" 
    sudo "$package_manager" install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y >/dev/null 2>&1  # Instala silenciosamente
    
    # add user to docker
    if [ "$(whoami)" != "root" ]; then
        sudo usermod -aG docker $USER
    fi
    
    validate_installation_tools "docker"
}

# Función para instalar Docker Compose
install_docker_compose() {
    # Comprobar si Docker Compose ya está instalado
    if command -v docker-compose &>/dev/null; then
        echo "✅ docker Compose ya está instalado en el sistema."
        return 0
    fi

    # Descargar Docker Compose
    echo "Descargando Docker Compose $COMPOSE_VERSION..."
    sudo curl -SL "$COMPOSE_URL" -o "$COMPOSE_PATH"

    # Asignar permisos de ejecución
    sudo chmod +x "$COMPOSE_PATH"

    # Verificar la instalación
    if command -v docker-compose &>/dev/null; then
        echo "✅ docker compose se ha instalado correctamente."
        return 0
    else
        echo "❌ Error: No se pudo instalar docker compose."
        return 1
    fi
}

###############################################
#           Uninstall tools                   #
###############################################

# Uninstall tools
uninstall_tools() {
    local tools=("$@")
    for tool in "${tools[@]}"; do
        if ! type "$tool" &>/dev/null; then
            echo "⚙️ Uninstall $tool..."
            if [ "$package_manager" = "apt" ]; then
                sudo apt purge "$tool" -y >/dev/null 2>&1  # Redirigir salida
            elif [ "$package_manager" = "yum" ]; then
                sudo yum purge "$tool" -y >/dev/null 2>&1  # Redirigir salida
            fi
        else
            echo "✅ $tool is already uninstalled."
        fi
    done
}