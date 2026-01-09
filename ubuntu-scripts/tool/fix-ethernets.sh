#!/bin/bash
set -e

echo "[EEE-FIX] Detecting wired Ethernet interfaces..."

for IFACE_PATH in /sys/class/net/*; do
    IFACE=$(basename "$IFACE_PATH")

    [[ "$IFACE" == "lo" ]] && continue
    [[ ! -e /sys/class/net/$IFACE/device ]] && continue
    [[ -d /sys/class/net/$IFACE/wireless ]] && continue
    [[ -d /sys/class/net/$IFACE/bridge ]] && continue

    TYPE=$(cat /sys/class/net/$IFACE/type 2>/dev/null || echo "")
    [[ "$TYPE" != "1" ]] && continue

    DEV_SUBSYS=$(readlink -f /sys/class/net/$IFACE/device/subsystem 2>/dev/null || echo "")

    echo
    echo "[EEE-FIX] Processing interface: $IFACE"

    ethtool "$IFACE" || true
    if [[ "$DEV_SUBSYS" == *pci* ]]; then
        echo "  - Type: PCI Ethernet (EEE applied)"

        echo "  - Disabling EEE..."
        ethtool --set-eee "$IFACE" eee off &>/dev/null || true
        sleep 1

        echo "  - Disabling auto-negotiation of pause parameters..."
        ethtool -A "$IFACE" rx off tx off &>/dev/null || true

        echo "  - Performing soft reset..."
        ip link set "$IFACE" down
        sleep 2
        ip link set "$IFACE" up
        sleep 2

        echo "  - Re-enabling EEE..."
        ethtool --set-eee "$IFACE" eee on &>/dev/null || true
        sleep 1

        ethtool "$IFACE" || true
    elif [[ "$DEV_SUBSYS" == *usb* ]]; then
        echo "  - Type: USB Ethernet (EEE ignored)"

        echo "  - Performing soft reset..."
        ip link set "$IFACE" down
        sleep 2
        ip link set "$IFACE" up
        sleep 2

        ethtool "$IFACE" || true
    else
        echo "  - Unknown type, ignoring."
    fi
done

echo
echo "[EEE-FIX] ✅ Done."
