# Install p10k for your user
install_p10k() {
    echo -e "\n${GREEN}Config p10k to zsh to user:${WHITE} $USER ${NONE}"

    # Check if Powerlevel10k directory already exists
    if [ -d "$HOME/powerlevel10k" ]; then
        echo -e "Powerlevel10k is already installed for user: ${WHITE}$USER${NONE} in $HOME/powerlevel10k. ✅"
        return 0  # Exit without doing anything further
    fi

    # Download p10k
    echo -e "\n${GREEN}Downloading Powerlevel10k...${NONE}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

    # Check if cloning was successful
    if [ $? -eq 0 ]; then
        echo -e "Powerlevel10k has been downloaded successfully."

        # Move .p10k.zsh from "release" directory to user's home directory
        if [ -f "$TEMP_DIR/.p10k.zsh" ]; then
            sudo mv "$TEMP_DIR/.p10k.zsh" "$HOME"
        fi

        echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

        # Validate installation and set zsh as default in shell terminal
        if [ -d "$HOME/powerlevel10k" ]; then
            echo -e "Powerlevel10k has been installed successfully for user: ${WHITE}$USER${NONE} in $HOME/powerlevel10k. ✅"
            
            if which "zsh" &>/dev/null; then
                echo -e "\n${GREEN}Change shell to user's default ${PURPURE}zsh ${NONE}..."
                sudo usermod --shell /usr/bin/zsh $USER
                echo "✅ Configured zsh as the default shell successfully."
                return 0  # Success
            else
                echo  "❌ Error: Failed to configure default zsh."
                return 1  # Error
            fi
        else
            echo -e "❌ Error: Could not install Powerlevel10k"
        fi
    else
        echo -e "❌ Error: Cloning Powerlevel10k failed."
    fi
}

install_p10k_user_root() {
    echo -e "\n${GREEN}${BOLD}Config p10k to zsh to user:${RED} root ${NONE}"

    # Check if Powerlevel10k directory already exists for root
    local p10k=$(sudo sh -c 'cd ~root && ls | grep -w "powerlevel10k"')
    if [ "$p10k" = "powerlevel10k" ]; then
        echo -e "Powerlevel10k is already installed for user: ${WHITE}root${NONE} in /root/powerlevel10k. ✅"
        return 0  # Exit without doing anything further
    fi

    # Download p10k
    echo -e "\n${GREEN}Downloading Powerlevel10k...${NONE}"
    sudo sh -c 'git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k'

    # Check if cloning was successful
    if [ $? -eq 0 ]; then
        echo -e "Powerlevel10k has been downloaded successfully."

        sudo sh -c 'echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc'

        # Move .p10k.zsh from "templates" directory to user's home directory
        if [ -f "$TEMP_DIR/.p10k_.zsh" ]; then
            sudo sh -c '
                cp ./templates/.p10k_.zsh ~/
                cd ~/
                mv .p10k_.zsh .p10k.zsh    
            '
        fi

        # Validate installation and set zsh as default in shell terminal for root
        local p10k=$(sudo sh -c 'cd ~root && ls | grep -w "powerlevel10k"')
        if [ "$p10k" = "powerlevel10k" ]; then
            echo -e "Powerlevel10k has been installed successfully for user: ${WHITE}root${NONE} in /root/powerlevel10k. ✅"
        
            if which "zsh" &>/dev/null; then
                echo -e "\n${GREEN}Change shell to user's default ${PURPURE}zsh ${NONE}..."
                sudo sh -c 'usermod --shell /usr/bin/zsh root'
                echo "✅ Configured zsh as the default shell successfully."
                return 0  # Success
            else
                echo  "❌ Error: Failed to configure default zsh."
                return 1  # Error
            fi
        else
            echo -e "❌ Error: Could not install Powerlevel10k"
        fi
    else
        echo -e "❌ Error: Cloning Powerlevel10k failed."
    fi
}

# Install lsd
install_lsd() {
    # Check if lsd is installed
    if command -v lsd &>/dev/null; then
        echo "✅ lsd is already installed on your system."
    else    
        local temp_dir="$(mktemp -d)"

        # Download and unzip Hacknet Fonts
        echo -e "⚙️ Download ${PURPURE}lsd${NONE} to use as ${RED}ls${NONE}..."
        if wget -q "$LSD_URL" -O "$temp_dir/lsd-musl_1.0.0_amd64.deb"; then
            if sudo dpkg -i "$temp_dir/lsd-musl_1.0.0_amd64.deb"; then
                echo -e "✅ ${PURPURE}lsd${NONE} is already uninstalled!"

                # Add aliases for lsd to your .zshrc
                echo -e "\n# Manual aliases for lsd" >> ~/.zshrc
                echo 'alias ll="lsd -lh --group-dirs=first"' >> ~/.zshrc
                echo 'alias la="lsd -a --group-dirs=first"' >> ~/.zshrc
                echo 'alias l="lsd --group-dirs=first"' >> ~/.zshrc
                echo 'alias lla="lsd -lha --group-dirs=first"' >> ~/.zshrc
                echo 'alias ls="lsd --group-dirs=first"' >> ~/.zshrc
                echo 'alias cat="bat"' >> ~/.zshrc
                echo -e "✅ Aliases for ${PURPURE}lsd${NONE} configured in your .zshrc."
            else
                echo -e "❌ Error: Could not install ${RED}lsd${None} ${GREEN}or is it already installed.${NONE}"
            fi
        else
            echo "❌ Error: Failed to download DEB package from URL."
        fi
    fi
}

# Install plugins to zsh and add sources to .zshrc
install_zsh_plugins() {
    # Path where plugins are installed
    plugin_dir="/usr/share"

    # Iterate over the list of plugins
    for plugin in "${PLUGINS_TO_ZSH[@]}"; do
        plugin_path="$plugin_dir/$plugin"

        # Check if the plugin directory exists
        if [ -d "$plugin_path" ]; then
            echo "✅ Plugin $plugin is already installed."
            
            # Add source to .zshrc if it's not already present
            if ! grep -q "source $plugin_path/$plugin.zsh" ~/.zshrc; then
                echo "source $plugin_path/$plugin.zsh" >> ~/.zshrc
                echo "✅ Source added to .zshrc for plugin $plugin."
            fi
        else
            echo "⚙️ Installing plugin $plugin..."
            if sudo $package_manager install $plugin; then
                echo "✅ Plugin $plugin installed successfully."
                
                # Add source to .zshrc if it's not already present
                if ! grep -q "source $plugin_path/$plugin.zsh" ~/.zshrc; then
                    echo "source $plugin_path/$plugin.zsh" >> ~/.zshrc
                    echo "✅ Source added to .zshrc for plugin $plugin."
                fi
            else
                echo "❌ Error: Failed to install plugin $plugin."
            fi
        fi
    done
}

config_zsh() {
    # Path to the .zshrc file in your normal user directory
    zshrc_user_path="/home/$USER/.zshrc"

    # Path to the .zshrc file in your root user directory
    zshrc_root_path="/root/.zshrc"

    # Check if the .zshrc file exists in your normal user directory
    if [ -f "$zshrc_user_path" ]; then
        # Check if the .zshrc file in root is a symbolic link
        local is_symbolic=$(sudo sh -c 'cd ~root && file .zshrc')
        if [ "$is_symbolic" == ".zshrc: symbolic link to /home/$USER/.zshrc" ]; then
            # The .zshrc file in root is a symbolic link, no need to do anything
            echo "✅ Root user's .zshrc file is already a symbolic link. Skipping."
            return
        elif [ -f "$zshrc_root_path" ]; then
            # The .zshrc file in root is not a symbolic link, delete it
            sudo rm "$zshrc_root_path"
            echo -e "\nRoot user's .zshrc file deleted."

            # Create a symbolic link in root user pointing to the .zshrc of your normal user
            sudo ln -s "$zshrc_user_path" "$zshrc_root_path"
            echo "✅ Symbolic link for .zshrc created in root user."

            # Add the configurations to the .zshrc file of your normal user
            cat <<EOL >>"$zshrc_user_path"

# Set up the prompt
autoload -Uz promptinit

setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Manual configuration
PATH=/root/.local/bin:/snap/bin:/usr/sandbox/:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

# Finalize Powerlevel10k instant prompt. Should stay at the bottom of ~/.zshrc.
(( ! \${+functions[p10k-instant-prompt-finalize]} )) || p10k-instant-prompt-finalize
EOL
            echo "✅ Configurations added to .zshrc of normal user."
        fi
    else
        echo "❌ The file .zshrc of user $USER not found."
    fi
}