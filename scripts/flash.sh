#!/bin/bash
# Flash VBdev OS ke perangkat mobile

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "╔══════════════════════════════════════╗"
echo "║   VBdev OS Mobile Device Flasher    ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Check for device
if [ -z "$1" ]; then
    echo "${YELLOW}Usage: $0 [DEVICE_NAME]${NC}"
    echo ""
    echo "Supported devices:"
    echo "  - pinephone"
    echo "  - raspberry-pi"
    echo "  - generic-arm"
    exit 1
fi

DEVICE=$1

# Check ADB/Fastboot
check_tools() {
    if ! command -v adb &> /dev/null; then
        echo "${YELLOW}⚠${NC} ADB not found, installing..."
        sudo apt-get install -y android-tools-adb android-tools-fastboot
    fi
}

# Backup current system
backup_device() {
    echo "📦 Backing up current system..."
    adb pull /system system_backup/
    echo "${GREEN}✓${NC} Backup complete"
}

# Flash kernel
flash_kernel() {
    echo "⚡ Flashing kernel..."
    fastboot flash boot out/kernel/Image
    echo "${GREEN}✓${NC} Kernel flashed"
}

# Flash system
flash_system() {
    echo "💾 Flashing system image..."
    fastboot flash system out/system.img
    echo "${GREEN}✓${NC} System flashed"
}

# Main flash procedure
main() {
    echo "🔍 Detecting device: $DEVICE"
    
    check_tools
    
    echo ""
    echo -n "Continue with flash? This will erase device! (y/N): "
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "Starting flash procedure..."
        
        # Reboot to bootloader
        adb reboot bootloader
        sleep 5
        
        flash_kernel
        flash_system
        
        # Reboot
        fastboot reboot
        
        echo ""
        echo "${GREEN}✅ Flash complete!${NC}"
        echo "Device will now boot into VBdev OS"
    else
        echo "Flash cancelled."
    fi
}

main
