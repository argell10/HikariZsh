# Install Hack Nerd Font
install_hack_nerd_font() {
    # Verificar si la fuente está instalada
    if fc-list | grep -q "$font_name"; then
        echo "✅ $font_name ya está instalada en tu sistema."
    else    
        local temp_dir="$(mktemp -d)"

        # Descargar y descomprimir Hacknet Fonts
        echo "⚙️ Descargando y descomprimiendo Hack nerd Fonts..."
        if wget -q "$URL_HACK_NERD_FONTS" -O "$temp_dir/Hack.zip" && unzip -q "$temp_dir/Hack.zip" -d "$temp_dir"; then
            # Crear el directorio de fuentes si no existe
            sudo mkdir -p /usr/local/share/fonts

            # Mover la fuente a /usr/local/share/fonts/
            echo "📁 Moving Hack Nerd Font to /usr/local/share/fonts/..."
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
    fi
}

# Define una función para establecer la fuente Hack Nerd Font
set_hack_nerd_font() {
    # Verifica si la fuente está instalada antes de intentar establecerla
    if fc-list | grep -q "$FONT_NAME"; then
        # La fuente está instalada, establece la fuente y su tamaño
        gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default | awk -F \' '{print $2}')/ font "$FONT_NAME 10"
        
        if [ $? -eq 0 ]; then
            # Configuración exitosa, muestra un emoji de visto (✅)
            echo "La fuente Hack Nerd Font se ha establecido como la fuente predeterminada en la terminal. ✅"
        else
            # Configuración fallida, muestra un emoji de equis (❌)
            echo "Error: No se pudo establecer la fuente Hack Nerd Font en la terminal. ❌"
        fi
    else
        # La fuente no está instalada, muestra un mensaje de advertencia (⚠️)
        echo "Advertencia: La fuente ${FONT_NAME} no está instalada. No se ha cambiado la configuración de la fuente. ⚠️"
    fi
}
