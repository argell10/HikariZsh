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

# Define vars to configure

# Font
FONT_NAME='Hack Nerd Font'
URL_HACK_NERD_FONTS="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip"

# Docker compose
COMPOSE_VERSION='2.20.3'
COMPOSE_URL='https://github.com/docker/compose/releases/download/v$COMPOSE_VERSION/docker-compose-linux-x86_64'
COMPOSE_PATH='/usr/local/bin/docker-compose'

# lsd
LSD_URL='https://github.com/lsd-rs/lsd/releases/download/v1.0.0/lsd-musl_1.0.0_amd64.deb'

# Define tools, requeriments and plugins to install
TOOLS_REQUIREMENTS=(git sed make wget curl unzip)
TOOLS_REQUIREMENTS_P10K=("${TOOLS_REQUIREMENTS[@]}" tmux zsh)
TOOLS_TO_INSTALL=(vim htop nmap);

# plugins to zsh
PLUGINS_TO_ZSH=(zsh-autosuggestions zsh-syntax-highlighting)