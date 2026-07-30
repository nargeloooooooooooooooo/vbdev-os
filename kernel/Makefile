#by NarzX
```makefile
# Minimal kernel Makefile untuk VBdev OS Mobile

VERSION = 1
PATCHLEVEL = 0
SUBLEVEL = 0
EXTRAVERSION = -vbdev-mobile
NAME = Mobile Terminal

# Core configuration
CONFIG_MOBILE := y
CONFIG_TERMINAL := y
CONFIG_TOUCHSCREEN := y

obj-y := init/
obj-y := kernel/
obj-y := mm/
obj-y := drivers/
obj-y := fs/
obj-y := net/
obj-y += vbdev/

# Mobile-specific modules
obj-$(CONFIG_TOUCHSCREEN) += drivers/input/touchscreen/
obj-$(CONFIG_FB) += drivers/video/
obj-$(CONFIG_POWER) += drivers/power/

all: vmlinux

vmlinux: FORCE
	@echo "Building VBdev kernel for mobile..."
	$(MAKE) -f scripts/Makefile.build obj=.
	@echo "Kernel build complete!"

clean:
	find . -name "*.o" -delete
	find . -name "*.ko" -delete
	rm -f vmlinux

FORCE:
