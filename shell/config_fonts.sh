#!/bin/bash

# Install Hack Nerd Font
install_hack_nerd_font() {
    local download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip"
    local temp_dir="$(mktemp -d)"

    # Descargar y descomprimir Hacknet Fonts
    echo "⚙️ Descargando y descomprimiendo Hack nerd Fonts..."
    if wget -q "$download_url" -O "$temp_dir/Hack.zip" && unzip -q "$temp_dir/Hack.zip" -d "$temp_dir"; then
        # Crear el directorio de fuentes si no existe
        sudo mkdir -p /usr/local/share/fonts

        # Mover la fuente a /usr/local/share/fonts/
        echo "📁 Moving Hack Nerd Fonts to /usr/local/share/fonts/..."
        if sudo mv "$temp_dir"/*.ttf /usr/local/share/fonts/; then
            # Actualizar la caché de fuentes
            echo "⚙️ Updating font cache..."
            if sudo fc-cache -f -v >/dev/null 2>&1; then
                # Limpiar archivos temporales
                rm -rf "$temp_dir"
                echo -e "✅ Hack Nerd Fonts installed successfully.\n"
                return 0
            fi
        fi
    fi

    # En caso de error, limpiar archivos temporales y mostrar un mensaje de error
    rm -rf "$temp_dir"
    echo -e "❌ Error: Failed to install Hack Nerd Fonts.\n"
    return 1
}