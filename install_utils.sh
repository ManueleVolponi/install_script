#!/bin/bash

# This script is used to install initial packages and tools on a new Ubuntu system.
# it will check if the package is already installed or not before installing it.

packages=(
    "mysql, mysql -V, sudo apt update && sudo apt install -y mysql-server"
    "curl, curl --version, sudo apt update && sudo apt install -y curl"
    "nvm, nvm --version, curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && nvm --version && nvm install --lts"
    "apache2, apache2 -v, sudo apt update && sudo apt install -y apache2"
    "git, git --version, sudo apt update && sudo apt install -y git"
)

install_package() {
    PACKAGE_NAME=$1
    COMMAND_CHECK=$2
    INSTALL_COMMAND=$3

    if [ -z "$PACKAGE_NAME" ] || [ -z "$COMMAND_CHECK" ] || [ -z "$INSTALL_COMMAND" ]
    then
        echo "Error: install_package() requires 3 arguments."
        return 1
    fi

    if [ "$PACKAGE_NAME" == "nvm" ]
    then
        if [ -f "$HOME/.nvm/nvm.sh" ]
        then
            echo "$PACKAGE_NAME is already installed."
            return 0
        fi
    fi

    if $COMMAND_CHECK &> /dev/null
    then
        echo "$PACKAGE_NAME is already installed."
    else
        echo "Installing $PACKAGE_NAME..."
        $INSTALL_COMMAND
        echo "$PACKAGE_NAME has been installed."
    fi
}

for package in "${packages[@]}"
do
    # Use IFS to split the package info into separate variables
    IFS=',' read -r name check exec <<< "$package"
    install_package "$name" "$check" "$exec"
done

# Ask if user wants to install Python, PHP, or both
echo "Do you want to install Python, PHP, or both? (Enter: python/php/both)"
read -r INSTALL_CHOICE

# install Both Python and PHP
 if [[ -z "$INSTALL_CHOICE" ]] || ["$INSTALL_CHOICE" == "both" ]; then
    PY_INSTALLED=0
    PHP_INSTALLED=0

    if python3 --version &> /dev/null then
        echo "Python is already installed."
        PY_INSTALLED=1
    fi

    if php -v &> /dev/null then
        echo "PHP is already installed."
        PHP_INSTALLED=1
    fi

    if [ "$PY_INSTALLED" == 0 ]; then
        sudo apt update && sudo apt install -y python3 python3-pip
        echo "Python has been installed."
    fi

    if [ "$PHP_INSTALLED" == 0 ]; then
        sudo apt update && sudo apt install -y php
        echo "PHP has been installed."
    fi

    echo "Python and PHP are installed."
    python3 --version && php -v
 fi

#install Python
if [ "$INSTALL_CHOICE" == "python" ]; then
    if python3 --version &> /dev/null then
        echo "Python is already installed."
    else
        sudo apt update && sudo apt install -y python3 python3-pip
        echo "Python has been installed."
    fi
    python3 --version
fi

#install PHP
if [ "$INSTALL_CHOICE" == "php" ]; then
    if php -v &> /dev/null then
        echo "PHP is already installed."
    else
        sudo apt update && sudo apt install -y php
        echo "PHP has been installed."
    fi
    php -v
fi