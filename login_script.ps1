<#
.SYNOPSIS
This script continuously checks for internet connectivity and automatically logs into the Sharif University portal if the internet is disconnected.

.DESCRIPTION
The script pings a commonly accessible website (Google) to determine if internet access is available. If the ping fails, it assumes that the internet session has expired and attempts to log in using the specified credentials.

.PARAMETER checkIntervalSeconds
The interval in seconds at which the script checks the internet connection. Default is 300 seconds (5 minutes).

.EXAMPLE
.\login_script.ps1 -checkIntervalSeconds 600
This runs the script and checks the connection every 600 seconds (10 minutes).

.NOTES
- Make sure to replace 'yourUsername' and 'yourPassword' with your actual login credentials.
- Execution Policy: To run PowerShell scripts, you may need to change the PowerShell execution policy. This is controlled by your system's security settings.

  - To view the current execution policy, you can use:
    Get-ExecutionPolicy

  - To set the policy to allow local scripts, use:
    Set-ExecutionPolicy RemoteSigned
    This setting allows the execution of scripts written on your local machine.

  - For a single session, to bypass the policy, run the script as follows:
    powershell.exe -ExecutionPolicy Bypass -File ".\login_script.ps1" -checkIntervalSeconds 10

- To have this script run at startup and potentially hide the PowerShell window, follow the setup instructions below in the full help section.

.AUTHOR
Alireza Ghaderi
#>

param(
    [int]$checkIntervalSeconds = 300  # Default interval of 5 minutes
)

function Test-And-Login {
    $connection = Test-Connection google.com -Count 1 -Quiet
    if ($connection) {
        Write-Output "Internet connection is active."
    } else {
        Write-Output "Internet connection is down. Attempting to login..."
        $loginUrl = 'https://net2.sharif.edu/login'
        $username = 'yourUsername'
        $password = 'yourPassword'
        $form = @{
            username = $username
            password = $password
        }
        $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        try {
            $response = Invoke-WebRequest -Uri $loginUrl -Method Post -Body $form -SessionVariable session -ErrorAction Stop
            Write-Output "Login attempt was successful."
        } catch {
            Write-Output "Failed to login: $($_.Exception.Message)"
        }
    }
}

while ($true) {
    Test-And-Login
    Start-Sleep -Seconds $checkIntervalSeconds
}
