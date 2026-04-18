#!/bin/bash

echo "--- Starting hibernation readiness check ---"

# 1. Identify the active swap device
# `swapon` returns the path (e.g. /dev/sda3 or /swap.img)
SWAP_DEVICE=$(swapon --show=NAME --noheadings | head -n 1)

if [ -z "$SWAP_DEVICE" ]; then
    echo "ERROR: No active swap area found on the system."
    exit 1
fi

# 2. Verify whether the active swap is a PARTITION
IS_PART=$(lsblk -no TYPE "$SWAP_DEVICE")

if [ "$IS_PART" != "part" ]; then
    echo "ERROR: The active swap ($SWAP_DEVICE) is not a partition (type: $IS_PART)."
    echo "Hibernation using swap files (.img) requires additional offset steps not covered here."
    exit 1
fi

echo "Active valid swap device detected: $SWAP_DEVICE"

# 3. Compare Swap size vs RAM (use megabytes for clarity)
RAM_SIZE=$(free -m | awk '/^Mem:/{print $2}')
SWAP_SIZE=$(free -m | awk '/^Swap:/{print $2}')

echo "RAM: ${RAM_SIZE}MB | Swap: ${SWAP_SIZE}MB"

if [ "$SWAP_SIZE" -lt "$RAM_SIZE" ]; then
    echo "WARNING: Your Swap partition is smaller than system RAM."
    echo "This typically prevents hibernation from working correctly."
    read -p "Do you want to continue anyway? (y/n): " cont
    [[ "$cont" != "y" ]] && exit 1
fi

# 4. Safely modify /etc/default/grub
GRUB_FILE="/etc/default/grub"
RESUME_PARAM="resume=$SWAP_DEVICE"

if grep -q "resume=" "$GRUB_FILE"; then
    echo "The 'resume' parameter already exists in GRUB. Please review it manually to avoid duplication."
else
    echo "Backing up and configuring GRUB..."
    sudo cp "$GRUB_FILE" "${GRUB_FILE}.bak"
    
    # Add the resume parameter before the closing quote of the GRUB_CMDLINE_LINUX_DEFAULT line
    sudo sed -i "/GRUB_CMDLINE_LINUX_DEFAULT=/ s/\"$/ $RESUME_PARAM\"/" "$GRUB_FILE"
    
    echo "Updating GRUB (update-grub)..."
    sudo update-grub
    echo "Success! System is now configured to resume from: $SWAP_DEVICE"
fi

# 5. Ensure `polkitd-pkla` is installed to support hibernation without prompts
sudo apt install polkitd-pkla
if [[ ! -f /etc/polkit-1/rules.d/10-enable-hibernate.rules ]]
then
    echo "Creating polkit rule to allow hibernation without password..."
    sudo touch /etc/polkit-1/rules.d/10-enable-hibernate.rules
    echo 'polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.login1.hibernate" ||
        action.id == "org.freedesktop.login1.hibernate-multiple-sessions" ||
        action.id == "org.freedesktop.upower.hibernate" ||
        action.id == "org.freedesktop.login1.handle-hibernate-key" ||
        action.id == "org.freedesktop.login1.hibernate-ignore-inhibit")
    {
        return polkit.Result.YES;
    }
});' | sudo tee /etc/polkit-1/rules.d/10-enable-hibernate.rules > /dev/null
fi

# 6. On GNOME, install extension to show a Hibernate button
if [[ -f /usr/bin/gnome-session ]]
then 
    echo "Detected GNOME session. Installing GNOME extension to show Hibernate button..."
    echo "Installing gnome-extensions-cli (GNOME extensions CLI)..."
    sudo apt -y install python3-pip
    # On newer pip versions (Ubuntu 23 or higher), this variable is necessary to install gnome-extensions-cli
    export PIP_BREAK_SYSTEM_PACKAGES=1
    pip3 install --upgrade gnome-extensions-cli
    # Add local bin to PATH for this session
    export PATH=$PATH:~/.local/bin
    echo "Installing Hibernate Status Button extension..."
    gext install hibernate-status@dromi
fi

# 7. Criar script de drop cache para tornar a hibernação mais rápida (opcional)
read -p "Deseja criar um script para limpar o cache antes de hibernar? (Recomendado para hibernação mais rápida) (s/n): " create_cache_script
if [[ "$create_cache_script" == "s" ]]
then
    echo "Criando script de limpeza de cache..."
    sudo tee /usr/lib/systemd/system-sleep/pre-hibernate.sh > /dev/null <<EOF
#!/bin/bash
if [ "$1" = "pre" ] && [ "$2" = "hibernate" ]; then
    sync
    echo 3 > /proc/sys/vm/drop_caches
fi
EOF
    sudo chmod +x /usr/lib/systemd/system-sleep/pre-hibernate.sh
    echo "Script criado em /usr/lib/systemd/system-sleep/pre-hibernate.sh"
    echo "Ele será executado antes da hibernação."
fi

# 8. Reduzir o swappiness para melhorar a performance de hibernação (opcional)
read -p "Deseja reduzir o swappiness para melhorar a performance de hibernação? (s/n): " reduce_swappiness
if [[ "$reduce_swappiness" == "s" ]]
then
    echo "Reduzindo swappiness para 10..."
    sudo sysctl vm.swappiness=10
    # Tornar a mudança permanente
    if ! grep -q "vm.swappiness=10" /etc/sysctl.d/99-swappiness.conf; then
        echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-swappiness.conf
    fi
    echo "Swappiness reduzido para 10. Isso pode melhorar a performance de hibernação, mas pode afetar a performance geral do sistema em situações de pouca RAM."
fi  

echo "--- Process completed! A system reboot is recommended. ---"
