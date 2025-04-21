#!/bin/bash
echo 
read -r -p "Press any key to installing VS Code Extensions..."

# Essential
echo
echo "Installing Essentials..."
code --install-extension visualstudioexptteam.vscodeintellicode
code --install-extension visualstudioexptteam.vscodeintellicode-completions
code --install-extension pkief.material-icon-theme

# Git
echo
echo "Installing Git extensions..."
code --install-extension donjayamanne.githistory
code --install-extension gxl.git-graph-3
code --install-extension serhioromano.vscode-gitflow

# SQL
echo
echo "Installing SQL extensions..."
code --install-extension inferrinizzard.prettier-sql-vscode

# Java
echo
echo "Installing Java extensions..."
code --install-extension vscjava.vscode-java-pack
code --install-extension redhat.vscode-server-connector

# JavaScript
echo
echo "Installing JavaScript extensions..."
code --install-extension wallabyjs.console-ninja
