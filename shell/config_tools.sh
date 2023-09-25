#!/bin/bash

# Define tools, requeriments and plugins to install
tools_requirements=(git sed make wget curl unzip)
tools_to_install=(vim tmux htop nmap zsh);

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

# Function to validate the installation of a tool
validate_installation() {
    local tool="$1"
    if type "$tool" &>/dev/null; then
        echo "✅ $tool installed successfully."
        return 0  # Success
    else
        echo  "❌ Error: Failed to install $tool."
        return 1  # Error
    fi
}
