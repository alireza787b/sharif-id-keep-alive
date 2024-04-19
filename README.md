
# Sharif ID Keep Alive

This PowerShell script helps students at Sharif University of Technology maintain continuous internet access by automatically re-logging into the student portal. It's specifically designed for academic projects that require stable and uninterrupted internet connectivity.

## Disclaimer

This script is provided "as is" for educational purposes to aid students who require uninterrupted internet access for their studies and research. Use it at your own risk. Changes to the Sharif University login system may affect the script's functionality, necessitating updates. As of now (April 2024), the script does not support bypassing any form of captcha or other advanced security measures.

## Features

- Automatically logs into the Sharif University portal to maintain internet connectivity.
- Customizable intervals for connection checks.
- Adaptable to other login systems with some modifications.

## Setup Instructions

### Script Setup

1. Clone the repository or download `login_script.ps1`.
2. Open the script in a text editor.
3. Replace `'yourUsername'` and `'yourPassword'` with your actual Sharif University credentials.
4. Optionally, adjust the `checkIntervalSeconds` parameter to change the default check interval of 300 seconds (5 minutes).

### Running the Script

#### Manually

You can run the script manually from PowerShell:

```bash
PowerShell.exe -ExecutionPolicy Bypass -File "path	o\login_script.ps1"
```

Replace `"path	o\login_script.ps1"` with the actual path to your script.

#### At Startup

To have this script run at system startup:

1. Right-click on the downloaded `SharifLoginScriptStartup.lnk`.
2. Click on `Properties`.
3. In the `Target` field, replace `"C:\Users\path\to\repo\sharif-stay-alive\login_script.ps1"` with the actual path to where you have saved `login_script.ps1`.
4. Copy the modified shortcut to your system's Startup folder (type `shell:startup` in the Run dialog accessible via `Win + R`).

### Important Notes

- **Execution Policy**: The script includes a command to bypass the execution policy temporarily. If you prefer, you can permanently change your system's policy:

  ```bash
  Set-ExecutionPolicy RemoteSigned
  ```

  This change allows the execution of locally created scripts while blocking unsolicited scripts downloaded from the internet.

- **Security Considerations**: Storing sensitive information like usernames and passwords in scripts can be risky. Ensure your computer is secure and consider encrypting the script or using other methods to secure credentials.

## Contributing

Contributions to improve the script or adapt it to changes in the university's system are welcome. Please fork the repository and submit pull requests with your enhancements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
