#!/bin/bash
# Setup development environment untuk VBdev OS

set -e

echo "🔧 Setting up VBdev OS development environment..."

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "${GREEN}✓${NC} Linux detected"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "${YELLOW}⚠${NC} macOS detected - some features may not work"
else
    echo "${RED}✗${NC} Unsupported OS"
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."

if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y \
        build-essential \
        gcc-aarch64-linux-gnu \
        binutils-aarch64-linux-gnu \
        flex \
        bison \
        libncurses-dev \
        libssl-dev \
        git \
        make \
        device-tree-compiler
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm \
        base-devel \
        aarch64-linux-gnu-gcc \
        aarch64-linux-gnu-binutils \
        flex \
        bison \
        ncurses \
        openssl \
        git \
        make \
        dtc
fi

# Setup git hooks
echo "🔗 Setting up git hooks..."
if [ -d ".git" ]; then
    cp scripts/pre-commit .git/hooks/
    chmod +x .git/hooks/pre-commit
fi

# Create necessary directories
echo "📁 Creating directory structure..."
mkdir -p build/kernel
mkdir -p out/apps
mkdir -p out/package

# Download toolchain if needed
if ! command -v aarch64-linux-gnu-gcc &> /dev/null; then
    echo "${YELLOW}⚠${NC} Cross-compiler not found"
    echo "Install with: sudo apt-get install gcc-aarch64-linux-gnu"
fi

echo ""
echo "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "Quick start:"
echo "  make mobile_defconfig  - Configure kernel"
echo "  make all              - Build everything"
echo "  make flash            - Flash to device"
echo ""
echo "Happy coding! 📱"
