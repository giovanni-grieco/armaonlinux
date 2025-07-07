# ArmA 3 TeamSpeak Helper for Linux

This is a rework of the original helper script [armaonlinux](https://github.com/ninelore/armaonlinux) by [@ninelore](https://github.com/ninelore).

This script helps you run TeamSpeak 3 alongside ArmA 3 on Linux using Proton, allowing voice communication during gameplay.

The core concept behind this script is to install teamspeak 3 under the same arma 3 proton prefix.

## Requirements

- **Steam** (native package, not Flatpak)
- **Protontricks** (not Flatpak version)
- **ArmA 3** installed via Steam
- **TeamSpeak 3 installer** (.exe file)

## Installation

### Option 1: Git Clone
```bash
git clone https://github.com/giovanni-grieco/armaonlinux
cd armaonlinux
chmod +x Arma3Helper.sh
```

### Option 2: Direct Download
```bash
curl -O https://raw.githubusercontent.com/giovanni-grieco/armaonlinux/refs/heads/master/Arma3Helper.sh
chmod +x Arma3Helper.sh
```

### Option 3: Browser Download
1. Go to [Arma3Helper.sh](https://github.com/giovanni-grieco/armaonlinux/blob/master/Arma3Helper.sh)
2. Click the "Download raw file" button (top right)
3. Make it executable: `chmod +x Arma3Helper.sh`

## Setup Instructions

1. **Install and launch ArmA 3** through Steam at least once
2. **Download TeamSpeak 3** installer from the [official website](https://www.teamspeak.com/en/downloads/#ts3client)
3. **Install TeamSpeak** using the helper script:
   ```bash
   ./Arma3Helper.sh install path/to/TeamSpeak3-Client-win64-installer.exe
   ```
   ⚠️ **Important**: During installation, choose "Install for all users" and keep the default installation path!

4. **Launch TeamSpeak** for ArmA 3:
   ```bash
   ./Arma3Helper.sh
   ```
   Or use the application shortcut created in your applications menu.

## Usage

### GUI
You should have a shortcut in your application called 'Teamspeak 3 (ArmA3)'.


### Launch TeamSpeak for ArmA 3
If the gui shortcut is not present you can always launch teamspeak 3
```bash
./Arma3Helper.sh
```
⚠️ **Note**: Start ArmA 3 first, then launch TeamSpeak!

### Additional Commands

- **Debug information**: `./Arma3Helper.sh debug`
- **Wine configuration**: `./Arma3Helper.sh winecfg`
- **Update script**: `./Arma3Helper.sh update`

## Troubleshooting

- Ensure ArmA 3 is launched before starting TeamSpeak
- Make sure both Steam and Protontricks are native packages (not Flatpak)
- Check that TeamSpeak was installed "for all users" in the default location
- Use `./Arma3Helper.sh debug` to view configuration and paths
- If using custom installation or steam library location, make sure to edit the Arma3Helper.sh script with a text editor to change the relative paths 'COMPAT_DATA_PATH', 'STEAM_LIBRARY_PATH'

## License

GPL-2.0 - See the script header for full license information.