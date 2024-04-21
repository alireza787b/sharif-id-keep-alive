<#
.SYNOPSIS
This script continuously checks for internet connectivity and automatically logs into the Sharif University portal if the internet is disconnected.

.DESCRIPTION
The script pings Cloudflare's DNS resolver (1.1.1.1) to determine if internet access is available. If the ping fails, it assumes that the internet session has expired and attempts to log in using the specified credentials. It adjusts the check frequency based on the approaching automatic logout time.

.PARAMETER checkIntervalSeconds
The default interval in seconds at which the script checks the internet connection.

.PARAMETER fastCheckPrior
The time in seconds before the 8-hour mark to start checking more frequently.

.PARAMETER fastCheckPeriod
The interval in seconds for frequent checks before the 8-hour logout time.

.PARAMETER maxSessionDuration
The maximum session duration in seconds after which the network logs out (default 8 hours).

.EXAMPLE
.\login_script.ps1 -checkIntervalSeconds 300 -fastCheckPrior 60 -fastCheckPeriod 5 -maxSessionDuration 28800
This runs the script and checks the connection every 5 minutes, switching to every 5 seconds 60 seconds before the 8-hour mark.

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
https://www.linkedin.com/in/alireza787b/
#>

param(
    [int]$checkIntervalSeconds = 300,  # Default interval of 5 minutes
    [int]$fastCheckPrior = 60,         # Start fast check 60 seconds before the 8-hour mark
    [int]$fastCheckPeriod = 5,         # Interval in seconds for fast checking
    [int]$maxSessionDuration = 28800   # Default session duration 8 hours
)

$global:lastSuccessfulLogin = $null

function Test-And-Login {
    $currentTime = Get-Date
    $currentSleepInterval = $checkIntervalSeconds  # Default to normal interval

    if ($global:lastSuccessfulLogin -ne $null) {
        $timeSinceLastLogin = $currentTime - $global:lastSuccessfulLogin
        $timeLeft = $maxSessionDuration - $timeSinceLastLogin.TotalSeconds

        if ($timeLeft -le $fastCheckPrior) {
            $currentSleepInterval = $fastCheckPeriod
        } else {
            $currentSleepInterval = $checkIntervalSeconds
        }
    }

    $connection = Test-Connection 1.1.1.1 -Count 1 -Quiet
    if ($connection) {
        if ($global:lastSuccessfulLogin -eq $null) {
            Write-Output "${currentTime}: Internet connection is active. No successful logins yet."
        } else {
            $hours = [Math]::Floor($timeSinceLastLogin.TotalHours)
            $minutes = $timeSinceLastLogin.Minutes
            Write-Output "${currentTime}: Internet connection is active. Time since last successful login: ${hours} hours, ${minutes} minutes"
        }
    } else {
        Write-Output "${currentTime}: Internet connection is down. Attempting to login..."
        $loginUrl = 'https://net2.sharif.edu/login'
        $username = 'yourUsername'  # Replace with your username
        $password = 'yourPassword'  # Replace with your password
        $form = @{
            username = $username
            password = $password
        }
        $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        try {
            $response = Invoke-WebRequest -Uri $loginUrl -Method Post -Body $form -SessionVariable session -ErrorAction Stop
            $global:lastSuccessfulLogin = Get-Date
            Write-Output "${global:lastSuccessfulLogin}: Login attempt was successful."
        } catch {
            Write-Output "${currentTime}: Failed to login: $($_.Exception.Message)"
        }
    }

    # Explicitly returning the sleep interval
    Write-Output "Next check in $currentSleepInterval seconds."
    return $currentSleepInterval
}

while ($true) {
    $sleepTime = Test-And-Login
    Start-Sleep -Seconds $sleepTime
}
