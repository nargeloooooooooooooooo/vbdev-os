# VBdev OS 

![VBdev OS](https://img.shields.io/badge/VBdev-OS-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Mobile-orange)

**VBdev OS** adalah sistem operasi open source berbasis terminal yang dioptimalkan untuk perangkat mobile. Dibangun dengan fokus pada efisiensi, kecepatan, dan pengalaman terminal murni.

## NOTE:VBdev OS is still in the early stages and just getting developed
## NOTE:VBdev masih dalam tahap perkermbangan,belum sepenuhnya utuh

## 🚀 Fitur Utama

- 📱 **Mobile-Optimized**: Dioptimalkan untuk layar sentuh dan keyboard virtual
- 💻 **Terminal-First**: Antarmuka berbasis terminal yang powerful
- 🔋 **Battery Efficient**: Manajemen daya yang agresif
- 🎨 **Customizable**: Tema dan konfigurasi yang fleksibel
- 🔒 **Secure by Default**: Keamanan tingkat kernel
- 📦 **Lightweight**: Hanya menggunakan resource minimal

## 📋 Persyaratan Sistem

- RAM: 512MB minimum (1GB recommended)
- Storage: 2GB minimum
- Processor: ARM/ARM64 atau x86
- Display: 4" - 7" touchscreen

## 🛠️ Instalasi

```bash
# Clone repository
git clone https://github.com/nargeloooooooooooooooo/vbdev-os
cd OS

# Build system
make mobile_defconfig
make -j$(nproc)

# Flash ke device
./scripts/flash.sh --device [DEVICE_NAME]
