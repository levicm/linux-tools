# linux-tools

Scripts to configure and automate Linux environments (Ubuntu/Debian-based).

## Quick Start

### Run everything (recommended for a fresh system)

```bash
bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/config-all.sh)
```

### Run a specific script

```bash
bash <(wget -qO - https://raw.githubusercontent.com/levicm/linux-tools/refs/heads/main/ubuntu-scripts/<script-name>.sh)
```

---

## Main Scripts (Orchestrators)

These scripts are run by `config-all.sh` **in this order**:

| # | Script | Description |
|---|--------|-------------|
| 1 | `prepare-linux.sh` | Prepares the environment: sets local RTC (compatible with Windows dual-boot), updates the system via apt-fast, installs curl, wget, Flatpak and GIT |
| 2 | `install-commands.sh` | Installs terminal utilities: htop, plocate, tree, fd-find, neofetch, fzf, speedtest |
| 3 | `install-essential-apps.sh` | Installs essential apps: GNOME Tweaks, Extension Manager, Synaptic, Remmina, Gear Lever, Sublime Text, Google Chrome, FSearch |
| 4 | `install-dev-tools.sh` | Dev tools orchestrator (calls VSCode, Eclipse, Postman scripts) |
| 5 | `install-media-apps.sh` | Media apps orchestrator (calls Spotify and EasyEffects scripts) |
| 6 | `install-gnome-extensions.sh` | Installs GNOME extensions infrastructure: gnome-browser-connector, gnome-extensions-cli |
| 7 | `install-office-apps.sh` | Installs office apps: PDF Sam, WPS Office |
| 8 | `install-ttf-fonts.sh` | Detects system font directory and prepares TTF font installation (required for WPS) |
| 9 | `install-nautilus-extensions.sh` | Nautilus extensions: nautilus-admin, VSCode integration, custom scripts |

---

## Scripts by Category

### Cloud Storage (`cloud-storage/`)

| Script | Description |
|--------|-------------|
| `install-insync.sh` | Installs Insync (Google Drive client) from official repository |
| `install-onedrive-by-rclone.sh` | Installs and configures RClone for OneDrive mounting (interactive) |
| `install-onedriver.sh` | Installs OneDriver (alternative OneDrive client) from OpenSUSE repository |

### Development (`development/`)

**Java & Build Tools:**

| Script | Description |
|--------|-------------|
| `install-openjdk-21.sh` | Installs OpenJDK 21 with `update-alternatives` configuration |
| `install-oracle-java-11.sh` | Installs Oracle JDK 11 with JAVA_HOME and `update-alternatives` |
| `install-oracle-java-17.sh` | Installs Oracle JDK 17 with JAVA_HOME and `update-alternatives` |
| `install-oracle-java-20.sh` | Installs Oracle JDK 20 with JAVA_HOME and `update-alternatives` |
| `install-maven-3.sh` | Installs Apache Maven 3.9.x (latest version detected dynamically) |
| `install-liquibase.sh` | Installs Liquibase (database change management tool) |

**IDEs & Editors:**

| Script | Description |
|--------|-------------|
| `install-vscode.sh` | Installs Visual Studio Code from Microsoft repository |
| `install-vscode-extensions.sh` | Installs VS Code extensions: IntelliCode, Git, SQL, Java, JavaScript |
| `install-eclipse.sh` | Installs Eclipse JEE 2024-12 with desktop shortcut |
| `install-postman.sh` | Installs Postman with desktop shortcut |

**Servers & DevOps:**

| Script | Description |
|--------|-------------|
| `install-docker.sh` | Installs Docker Engine + docker-compose, configures sudo-less access |
| `install-kubernetes.sh` | Installs kubectl v1.34 from official Kubernetes repository |
| `install-wildfly-26.sh` | Installs WildFly 26.1.0 |
| `install-wildfly-34.sh` | Installs WildFly 34.0.1 |
| `install-wildfly-36.sh` | Installs WildFly 36.0.1 |

**Web & Frontend:**

| Script | Description |
|--------|-------------|
| `install-node20-angular17.sh` | Installs Node.js v20 via fnm and Angular CLI v17 |

**Database:**

| Script | Description |
|--------|-------------|
| `install-debeaver.sh` | Installs DBeaver CE (universal database client) |

### Devices / Hardware (`device/`)

| Script | Description |
|--------|-------------|
| `enable-fingerprint.sh` | Installs fingerprint authentication (fprintd) and interactively enrolls a fingerprint |
| `install-epson-l355-driver.sh` | Installs drivers and scanning software for Epson L355 printer |

### Diagnostics (`diagnostics/`)

| Script | Description |
|--------|-------------|
| `system_diagnostics.sh` | Collects system diagnostics (CPU, memory, disk, network) and saves to a timestamped file |
| `compare_diagnostics.sh` | Compares two diagnostic files to identify changes between measurements |

### Hibernation (`hibernation/`)

Scripts to configure hibernation — **run in this order** if setting up from scratch:

| # | Script | Description |
|---|--------|-------------|
| 1 | `enable-hibernation.sh` | Validates and enables hibernation (checks for adequate swap) |
| 2 | `install-hibernation-low-battery.sh` | Creates a systemd service that auto-hibernates when battery < 8% |
| 3 | `configure-sleep-then-hibernate.sh` | Configures suspend→hibernate behavior with GNOME idle settings |
| 4 | `install-sleep-then-hibernate-hook.sh` | Implements "suspend then hibernate" via systemd sleep hooks (workaround for gsd-power on GNOME) |

### Internet & Network (`internet/`)

| Script | Description |
|--------|-------------|
| `install-google-chrome.sh` | Installs Google Chrome from official Google repository |
| `install-tailscale.sh` | Installs Tailscale VPN with auto-start configuration |

### Launcher (`launcher/`)

| Script | Description |
|--------|-------------|
| `install-ulauncher.sh` | Installs ULauncher (keyboard-driven application launcher) |

### Media (`media/`)

| Script | Description |
|--------|-------------|
| `install-spotify.sh` | Installs Spotify from official repository |
| `install-easyeffects.sh` | Installs EasyEffects (audio effects) with GNOME extension support |

### Office (`office/`)

| Script | Description |
|--------|-------------|
| `install-wps.sh` | Installs WPS Office with libtiff.so.5 compatibility fix |

### Security (`security/`)

| Script | Description |
|--------|-------------|
| `install-bitwarden.sh` | Installs Bitwarden (password manager) via Flatpak |

### Tools (`tool/`)

| Script | Description |
|--------|-------------|
| `install-fsearch.sh` | Installs FSearch (fast file search utility) via PPA |
| `install-fzf.sh` | Installs fzf (command-line fuzzy finder) via git clone |
| `install-remmina.sh` | Installs Remmina (remote desktop client) with RDP plugin |
| `install-speedtest.sh` | Installs Ookla Speedtest CLI |
| `install-sublime-text.sh` | Installs Sublime Text from official repository |
| `install-gear-lever.sh` | Installs Gear Lever (AppImage manager) |
| `fix-ethernets.sh` | Detects and configures wired Ethernet interfaces |
| `update-gtk-icons.sh` | Updates GTK icon cache (Hicolor, Yaru, Adwaita) |

### Cleanup (`clear/`)

| Script | Description |
|--------|-------------|
| `clear-flatpak-repo.sh` | Removes unused Flatpak packages, repairs the repository and clears cache |

---

## Requirements

- Ubuntu / Debian-based Linux
- GNOME desktop (some scripts are GNOME-specific)
- sudo/root access
- Internet connection
