#!/bin/bash

#######################################
# Tailscale 
#######################################
install_tailscale() {
    if command -v tailscale >/dev/null 2>&1; then
        echo "==> Tailscale already installed."
    else
        echo "==> Installing Tailscale..."
        curl -fsSL https://tailscale.com/install.sh | sh
    fi

    if sudo tailscale status >/dev/null 2>&1; then
        echo "==> Tailscale already running."
    else
        echo "==> Starting Tailscale..."
        sudo tailscale up --accept-routes --accept-dns
    fi
}

#######################################
# KDE – tail-tray
#######################################
install_kde_tray() {
    if dpkg -s tail-tray >/dev/null 2>&1; then
        echo "==> tail-tray already installed."
    else
        echo "==> Installing tail-tray..."

        BASE_URL="https://github.com/SneWs/tail-tray/releases/download/v0.2.28"

        case "$UBUNTU_VERSION" in
            24.04)
                PKG="tail-tray_0.2.28ubuntu-24.04-noble1_${ARCH}.deb"
                ;;
            25.10)
                PKG="tail-tray_0.2.28ubuntu-25.10-plucky1_${ARCH}.deb"
                ;;
            *)
                PKG="tail-tray_0.2.28debian-trixie1_${ARCH}.deb"
                ;;
        esac

        cd /tmp
        curl -LO "$BASE_URL/$PKG"
        sudo dpkg -i "$PKG" || sudo apt -f install -y
    fi

    enable_kde_autostart
}

enable_kde_autostart() {
    AUTOSTART_DIR="$HOME/.config/autostart"
    DESKTOP_FILE="/usr/share/applications/tail-tray.desktop"
    AUTOSTART_LINK="$AUTOSTART_DIR/tail-tray.desktop"

    if [[ ! -f "$DESKTOP_FILE" ]]; then
        echo "⚠️ tail-tray desktop file not found."
        return
    fi

    mkdir -p "$AUTOSTART_DIR"

    if [[ -L "$AUTOSTART_LINK" ]]; then
        echo "==> tail-tray autostart already enabled."
    else
        echo "==> Enabling tail-tray autostart (KDE)..."
        ln -s "$DESKTOP_FILE" "$AUTOSTART_LINK"
    fi
}

#######################################
# GNOME – extension
#######################################
install_gnome_extension_cli() {
    if ! command -v gext >/dev/null 2>&1; then
        echo "==> Installing gnome extensions CLI..."
        sudo apt -y install gnome-browser-connector python3-pip
        export PIP_BREAK_SYSTEM_PACKAGES=1
        pip3 install --upgrade gnome-extensions-cli

        if ! grep -q '\.local/bin' ~/.bashrc; then
            echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
        fi

        export PATH="$PATH:$HOME/.local/bin"
    else
        echo "==> gnome-extensions-cli already installed."
    fi
}

install_gnome_tray() {
    install_gnome_extension_cli

    if gext list | grep -q tailscale-status; then
        echo "==> Tailscale GNOME extension already installed."
    else
        echo "==> Installing Tailscale GNOME Shell extension..."
        gext install 5112
    fi
}

#######################################
# Main
#######################################
install_tailscale

DESKTOP="${XDG_CURRENT_DESKTOP,,}"

if [[ "$DESKTOP" == *kde* || "$DESKTOP" == *plasma* ]]; then
    echo "==> KDE detected."
    install_kde_tray
elif [[ "$DESKTOP" == *gnome* ]]; then
    echo "==> GNOME detected."
    install_gnome_tray
else
    echo "==> Unknown desktop environment: $XDG_CURRENT_DESKTOP"
    echo "Skipping tray installation."
fi
echo "==> Done!"