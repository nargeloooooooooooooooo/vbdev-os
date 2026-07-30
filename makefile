# VBdev OS Build System
# Makefile for mobile-optimized build

ARCH ?= arm64
CROSS_COMPILE ?= aarch64-linux-gnu-
BUILD_DIR ?= build
OUT_DIR ?= out

# Kernel configuration for mobile
MOBILE_DEFCONFIG := vbdev_mobile_defconfig

.PHONY: all clean mrproper mobile_defconfig menuconfig help

all: kernel shell apps

help:
	@echo "VBdev OS Build System"
	@echo "======================"
	@echo "Targets:"
	@echo "  all              - Build everything"
	@echo "  kernel           - Build Linux kernel"
	@echo "  shell            - Build VBdev shell"
	@echo "  apps             - Build system applications"
	@echo "  mobile_defconfig - Set mobile configuration"
	@echo "  menuconfig       - Open kernel menuconfig"
	@echo "  clean            - Clean build files"
	@echo "  flash            - Flash to device"

kernel:
	@echo "Building kernel for mobile..."
	$(MAKE) -C kernel ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(BUILD_DIR)/kernel
	@echo "Kernel built successfully!"

shell:
	@echo "Building VBdev Shell..."
	$(MAKE) -C shell
	cp shell/vsh $(OUT_DIR)/

apps:
	@echo "Building system apps..."
	$(MAKE) -C apps
	cp -r apps/build/* $(OUT_DIR)/apps/

mobile_defconfig:
	@echo "Applying mobile configuration..."
	$(MAKE) -C kernel ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(BUILD_DIR)/kernel $(MOBILE_DEFCONFIG)

menuconfig:
	$(MAKE) -C kernel ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(BUILD_DIR)/kernel menuconfig

flash:
	@echo "Flashing to device..."
	./scripts/flash.sh

package:
	@echo "Creating installation package..."
	mkdir -p $(OUT_DIR)/package
	cp $(BUILD_DIR)/kernel/arch/arm64/boot/Image $(OUT_DIR)/package/
	cp $(OUT_DIR)/vsh $(OUT_DIR)/package/
	tar -czf vbdev-os-mobile.tar.gz -C $(OUT_DIR)/package .
	@echo "Package created: vbdev-os-mobile.tar.gz"

clean:
	@echo "Cleaning build files..."
	$(MAKE) -C kernel clean
	$(MAKE) -C shell clean
	$(MAKE) -C apps clean
	rm -rf $(BUILD_DIR) $(OUT_DIR)# VBdev OS Build System
# Makefile for mobile-optimized build

ARCH ?= arm64
CROSS_COMPILE ?= aarch64-linux-gnu-
BUILD_DIR ?= build
OUT_DIR ?= out

# Kernel configuration for mobile
MOBILE_DEFCONFIG := vbdev_mobile_defconfig

.PHONY: all clean mrproper mobile_defconfig menuconfig help

all: kernel shell apps

help:
	@echo "VBdev OS Build System"
	@echo "======================"
	@echo "Targets:"
	@echo "  all              - Build everything"
	@echo "  kernel           - Build Linux kernel"
	@echo "  shell            - Build VBdev shell"
	@echo "  apps             - Build system applications"
	@echo "  mobile_defconfig - Set mobile configuration"
	@echo "  menuconfig       - Open kernel menuconfig"
	@echo "  clean            - Clean build files"
	@echo "  flash            - Flash to device"

kernel:
	@echo "Building kernel for mobile..."
	$(MAKE) -C kernel ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(BUILD_DIR)/kernel
	@echo "Kernel built successfully!"

shell:
	@echo "Building VBdev Shell..."
	$(MAKE) -C shell
	cp shell/vsh $(OUT_DIR)/

apps:
	@echo "Building system apps..."
	$(MAKE) -C apps
	cp -r apps/build/* $(OUT_DIR)/apps/

mobile_defconfig:
	@echo "Applying mobile configuration..."
	$(MAKE) -C kernel ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(BUILD_DIR)/kernel $(MOBILE_DEFCONFIG)

menuconfig:
	$(MAKE) -C kernel ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) \
		O=$(BUILD_DIR)/kernel menuconfig

flash:
	@echo "Flashing to device..."
	./scripts/flash.sh

package:
	@echo "Creating installation package..."
	mkdir -p $(OUT_DIR)/package
	cp $(BUILD_DIR)/kernel/arch/arm64/boot/Image $(OUT_DIR)/package/
	cp $(OUT_DIR)/vsh $(OUT_DIR)/package/
	tar -czf vbdev-os-mobile.tar.gz -C $(OUT_DIR)/package .
	@echo "Package created: vbdev-os-mobile.tar.gz"

clean:
	@echo "Cleaning build files..."
	$(MAKE) -C kernel clean
	$(MAKE) -C shell clean
	$(MAKE) -C apps clean
	rm -rf $(BUILD_DIR) $(OUT_DIR)
