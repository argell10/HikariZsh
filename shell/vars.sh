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
# Docker compose
COMPOSE_VERSION='2.20.3'
COMPOSE_URL='https://github.com/docker/compose/releases/download/v$COMPOSE_VERSION/docker-compose-linux-x86_64'
COMPOSE_PATH='/usr/local/bin/docker-compose'


# Define tools, requeriments and plugins to install
TOOLS_REQUIREMENTS=(git sed make wget curl unzip)
TOOLS_REQUIREMENTS_P10K=("${TOOLS_REQUIREMENTS[@]}" tmux zsh)
TOOLS_TO_INSTALL=(vim htop nmap);