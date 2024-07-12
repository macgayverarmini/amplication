#!/bin/bash

# Function to install Node.js using NVM
install_nodejs() {
    # Install NVM
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

    # Source NVM script
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/.nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Install Node.js 18.12.1
    nvm install v18.12.1
    node -v
}

# Function to install npm 9.0.0
install_npm() {
    npm install -g npm@9.0.0
}

# Function to install Docker
install_docker() {
    # Remove previous Docker packages
    sudo apt-get remove docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc

    # Configure Docker APT repository
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    docker -v
}

# Function to install Docker Compose v2.27.2
install_docker_compose() {
    # Download Docker Compose
    wget https://github.com/docker/compose/releases/download/v2.27.2/docker-compose-linux-x86_64

    # Move to bin path
    sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose

    # Make executable
    sudo chmod +x /usr/local/bin/docker-compose

    docker-compose -v
}

# Function to adjust docker.sock permissions
adjust_docker_sock_permissions() {
    sudo chmod 666 /var/run/docker.sock
}

# Function to adjust fs.inotify.max_user_watches
adjust_max_user_watches() {
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
    cat /proc/sys/fs/inotify/max_user_watches
}

# Run final commands
final_install(){
    npm install
    npm run setup:dev
    npm run docker:dev
    npm run db:migrate:deploy
}

# Main script execution starts here

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo."
    exit 1
fi

# Install prerequisites
apt-get update
apt-get install -y wget curl

# Execute functions
install_nodejs
install_npm
install_docker
install_docker_compose
adjust_docker_sock_permissions
adjust_max_user_watches
final_install

# Instructions for Amplification setup and GitHub connection are manually executed.
# Please refer to the tutorial for detailed steps.

echo "All setup steps completed. Continue with the Amplification setup and GitHub connection."
