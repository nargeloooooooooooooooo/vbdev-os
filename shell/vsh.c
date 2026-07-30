/*
 * VBdev Shell (vsh) - Terminal shell untuk VBdev OS Mobile
 * Copyright (c) 2024 VBdev Team
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <termios.h>

#define VSH_VERSION "1.0.0-mobile"
#define MAX_CMD_LEN 256
#define MAX_ARGS 64
#define HISTORY_SIZE 50

// ANSI Color codes untuk mobile display
#define COLOR_RESET   "\033[0m"
#define COLOR_PROMPT  "\033[1;32m"
#define COLOR_ERROR   "\033[1;31m"
#define COLOR_INFO    "\033[1;36m"

// Mobile-optimized commands
struct builtin_cmd {
    char *name;
    int (*func)(int argc, char **argv);
    char *help;
};

// Function declarations
int vsh_exit(int argc, char **argv);
int vsh_help(int argc, char **argv);
int vsh_clear(int argc, char **argv);
int vsh_battery(int argc, char **argv);
int vsh_brightness(int argc, char **argv);
int vsh_wifi(int argc, char **argv);
int vsh_touch_calibrate(int argc, char **argv);

struct builtin_cmd builtins[] = {
    {"exit", vsh_exit, "Keluar dari VBdev Shell"},
    {"help", vsh_help, "Tampilkan bantuan"},
    {"clear", vsh_clear, "Bersihkan layar terminal"},
    {"battery", vsh_battery, "Cek status baterai"},
    {"brightness", vsh_brightness, "Atur kecerahan layar"},
    {"wifi", vsh_wifi, "Kelola koneksi WiFi"},
    {"calibrate", vsh_touch_calibrate, "Kalibrasi touchscreen"},
    {NULL, NULL, NULL}
};

// Mobile-optimized prompt
void show_prompt() {
    char hostname[32];
    gethostname(hostname, sizeof(hostname));
    printf(COLOR_PROMPT "📱 vbdev@%s" COLOR_RESET " $ ", hostname);
    fflush(stdout);
}

// Parse input dengan mobile keyboard support
int parse_input(char *input, char **args) {
    int argc = 0;
    char *token = strtok(input, " \t\n");
    
    while (token != NULL && argc < MAX_ARGS - 1) {
        args[argc++] = token;
        token = strtok(NULL, " \t\n");
    }
    args[argc] = NULL;
    return argc;
}

// Execute commands
int execute_command(int argc, char **argv) {
    if (argc == 0) return 0;
    
    // Check builtins
    for (int i = 0; builtins[i].name != NULL; i++) {
        if (strcmp(argv[0], builtins[i].name) == 0) {
            return builtins[i].func(argc, argv);
        }
    }
    
    printf(COLOR_ERROR "Command tidak ditemukan: %s\n" COLOR_RESET, argv[0]);
    printf("Ketik 'help' untuk daftar perintah\n");
    return 1;
}

// Builtin: battery status
int vsh_battery(int argc, char **argv) {
    printf("🔋 Status Baterai:\n");
    printf("├─ Level: 85%%\n");
    printf("├─ Status: Charging\n");
    printf("├─ Temperature: 32°C\n");
    printf("└─ Health: Good\n");
    return 0;
}

// Builtin: brightness control
int vsh_brightness(int argc, char **argv) {
    if (argc < 2) {
        printf("💡 Kecerahan saat ini: 75%%\n");
        printf("Penggunaan: brightness [0-100]\n");
        return 0;
    }
    int level = atoi(argv[1]);
    if (level < 0 || level > 100) {
        printf(COLOR_ERROR "Level harus 0-100\n" COLOR_RESET);
        return 1;
    }
    printf("💡 Kecerahan diatur ke %d%%\n", level);
    return 0;
}

// Builtin: wifi manager
int vsh_wifi(int argc, char **argv) {
    if (argc < 2) {
        printf("📡 WiFi Manager\n");
        printf("├─ Status: Connected\n");
        printf("├─ SSID: VBdev-Network\n");
        printf("├─ Signal: ▂▄▆█ 95%%\n");
        printf("└─ IP: 192.168.1.100\n");
        printf("\nPenggunaan:\n");
        printf("  wifi scan    - Scan networks\n");
        printf("  wifi connect [SSID] [PASS]\n");
        printf("  wifi off     - Disable WiFi\n");
        return 0;
    }
    
    if (strcmp(argv[1], "scan") == 0) {
        printf("Scanning WiFi networks...\n");
        printf("📶 VBdev-Network    ▂▄▆█ 95%%\n");
        printf("📶 Home-WiFi        ▂▄▆_ 72%%\n");
        printf("📶 Coffee-Shop      ▂▄__ 45%%\n");
    }
    return 0;
}

// Builtin: touch calibration
int vsh_touch_calibrate(int argc, char **argv) {
    printf("🖐️ Touchscreen Calibration\n");
    printf("Ikuti petunjuk di layar:\n");
    printf("1. Sentuh pojok kiri atas [■]\n");
    printf("2. Sentuh pojok kanan bawah [■]\n");
    printf("Kalibrasi selesai!\n");
    return 0;
}

// Builtin: clear screen
int vsh_clear(int argc, char **argv) {
    printf("\033[2J\033[H");
    return 0;
}

// Builtin: help
int vsh_help(int argc, char **argv) {
    printf("\n");
    printf("╔════════════════════════════════╗\n");
    printf("║    VBdev OS Mobile Terminal    ║\n");
    printf("║        Version %s          ║\n", VSH_VERSION);
    printf("╚════════════════════════════════╝\n\n");
    printf("Perintah yang tersedia:\n\n");
    
    for (int i = 0; builtins[i].name != NULL; i++) {
        printf("  %-15s - %s\n", builtins[i].name, builtins[i].help);
    }
    
    printf("\n💡 Tips Mobile:\n");
    printf("  - Swipe up: Scroll ke atas\n");
    printf("  - Swipe down: Scroll ke bawah\n");
    printf("  - Double tap: Auto-complete\n");
    printf("  - Long press: Context menu\n\n");
    return 0;
}

// Builtin: exit
int vsh_exit(int argc, char **argv) {
    printf("Sampai jumpa! 👋\n");
    exit(0);
    return 0;
}

// Main shell loop
int main() {
    char input[MAX_CMD_LEN];
    char *args[MAX_ARGS];
    int argc;
    
    // Setup terminal
    setvbuf(stdout, NULL, _IONBF, 0);
    
    printf("\033[2J\033[H"); // Clear screen
    printf(COLOR_INFO);
    printf("╔════════════════════════════════════╗\n");
    printf("║     Selamat datang di VBdev OS     ║\n");
    printf("║        Mobile Terminal v%s        ║\n", VSH_VERSION);
    printf("╚════════════════════════════════════╝\n");
    printf(COLOR_RESET);
    printf("Ketik 'help' untuk bantuan\n\n");
    
    // Main loop
    while (1) {
        show_prompt();
        
        if (fgets(input, sizeof(input), stdin) == NULL) {
            printf("\n");
            break;
        }
        
        // Handle empty input
        if (strlen(input) <= 1) continue;
        
        argc = parse_input(input, args);
        execute_command(argc, args);
    }
    
    return 0;
}
