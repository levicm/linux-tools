#!/bin/bash

# Test if  hibernation is enabled
if ! systemctl hibernate --dry-run &>/dev/null; then
    echo "Hibernation is not enabled. Execute enable-hibernation.sh first."
    exit 1
fi

# Create verification script
sudo tee /usr/local/bin/hibernate-low-battery.sh > /dev/null <<'EOF'
#!/bin/bash
BATTERY_LEVEL=$(upower -i $(upower -e | grep BAT) | grep -E "percentage" | awk '{print $2}' | sed 's/%//')
STATE=$(upower -i $(upower -e | grep BAT) | grep -E "state" | awk '{print $2}')

logger -t hibernate-low-battery "Battery state: $STATE, level: $BATTERY_LEVEL%"

if [ "$STATE" = "discharging" ] && [ "$BATTERY_LEVEL" -le 8 ]; then
    logger -t hibernate-low-battery "Low battery detected. Attempting hibernation..."
    systemctl hibernate
fi
EOF
sudo chmod +x /usr/local/bin/hibernate-low-battery.sh

# Create service
sudo tee /etc/systemd/system/hibernate-low-battery.service > /dev/null <<'EOF'
[Unit]
Description=Hibernate on low battery

[Service]
Type=oneshot
ExecStart=/usr/local/bin/hibernate-low-battery.sh
EOF

# Create timer
sudo tee /etc/systemd/system/hibernate-low-battery.timer > /dev/null <<'EOF'
[Unit]
Description=Check battery level periodically

[Timer]
OnBootSec=5min
OnUnitActiveSec=1min

[Install]
WantedBy=timers.target
EOF

# Activate
sudo systemctl daemon-reload
sudo systemctl enable --now hibernate-low-battery.timer

echo "Service installed and enabled. The system will hibernate automatically when battery is low."

