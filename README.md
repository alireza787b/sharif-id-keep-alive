
# Sharif ID Keep Alive

This repository contains scripts to help students at Sharif University of Technology maintain continuous internet access by automatically re-logging into the student portal. It supports both Windows (PowerShell) and Linux (Bash) environments, ensuring stable and uninterrupted internet connectivity for academic projects.

## Disclaimer

This script is provided "as is" for educational purposes to aid students who require uninterrupted internet access for their studies and research. Use it at your own risk. Changes to the Sharif University login system may affect the script's functionality, necessitating updates. This document was created in May 2024, and network settings, IP addresses, or security measures might change.

## Features

- Automatically logs into the Sharif University portal to maintain internet connectivity.
- Customizable intervals for connection checks, with adaptive frequency adjustments approaching logout times.
- The script adapts the checking frequency dynamically based on the approaching automatic logout time, increasing its frequency to ensure continuous connectivity.
- Adaptable to other login systems with some modifications.

## Setup Instructions

### General Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/alireza787b/sharif-id-keep-alive.git
   ```
2. Navigate to the cloned directory:
   ```bash
   cd sharif-id-keep-alive
   ```

### Windows (PowerShell)

#### Script Setup

1. Open `login_script.ps1` in a text editor.
2. Replace `'yourUsername'` and `'yourPassword'` with your actual Sharif University credentials.
3. Optionally, adjust the `checkIntervalSeconds`, `fastCheckPrior`, `fastCheckPeriod`, and `maxSessionDuration` parameters to customize the check interval and adaptive check frequency behavior.

#### Running the Script

##### Manually

You can run the script manually from PowerShell:
   ```powershell
   PowerShell.exe -ExecutionPolicy Bypass -File "path\to\login_script.ps1"
   ```

##### At Startup

To have this script run at system startup:
1. Modify the `SharifLoginScriptStartup.lnk` shortcut to point to the location of `login_script.ps1`.
2. Place the shortcut in your system's Startup folder (`shell:startup`).

### Linux (Ubuntu)

#### Script Setup

1. Open `login_script.sh` in a text editor.
2. Replace `'yourUsername'` and `'yourPassword'` in the script with your actual Sharif University credentials.
3. Make the script executable:
   ```bash
   chmod +x login_script.sh
   ```

#### Running the Script as a Service

1. Create a systemd service file:
   ```bash
   sudo nano /etc/systemd/system/login_keep_alive.service
   ```
2. Add the following configuration, adjusting paths as necessary:
   ```ini
   [Unit]
   Description=Login Keep Alive Service
   After=network.target

   [Service]
   Type=simple
   User=alireza
   WorkingDirectory=/home/alireza/sharif-id-keep-alive
   ExecStart=/bin/bash /home/alireza/sharif-id-keep-alive/login_script.sh
   Restart=always
   RestartSec=10

   [Install]
   WantedBy=multi-user.target
   ```
3. Enable and start the service:
   ```bash
   sudo systemctl enable login_keep_alive.service
   sudo systemctl start login_keep_alive.service
   ```

### Important Notes

- **IP Conflict with Docker**: The default Docker subnet (`172.17.0.0/16`) may conflict with the Sharif University login server IP (`172.17.1.214`). To change the Docker default subnet, edit the `daemon.json` file:
  ```bash
  sudo nano /etc/docker/daemon.json
  ```
  Then modify the file to set a different subnet:
  ```json
  { "bip": "172.18.0.1/16" }
  ```
- **Security Considerations**: Storing usernames and passwords in scripts can be risky. Ensure your computer is secure and consider methods to secure credentials, like environment variables or encrypted storage.

## Contributing

Contributions to improve the script or adapt it to changes in the university's system are welcome. Please fork the repository and submit pull requests with your enhancements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
