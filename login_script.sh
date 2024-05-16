#!/bin/bash

# Configuration parameters
checkIntervalSeconds=300  # Default interval of 5 minutes
fastCheckPrior=60         # Start fast check 60 seconds before the 8-hour mark
fastCheckPeriod=5         # Interval in seconds for fast checking
maxSessionDuration=28800  # Default session duration 8 hours

# Save the last successful login time in a file
lastLoginFile="/tmp/last_successful_login.txt"
currentTime=$(date +%s)

# Function to check internet connectivity and log in
function test_and_login {
    local sleepTime=$checkIntervalSeconds  # Initialize sleepTime with default check interval

    if ping -c 1 1.1.1.1 >/dev/null 2>&1; then
        if [ ! -f "$lastLoginFile" ]; then
            echo "$currentTime" > "$lastLoginFile"
            echo "$(date): Internet connection is active. No successful logins yet."
        else
            lastSuccessfulLogin=$(cat "$lastLoginFile")
            timeSinceLastLogin=$((currentTime - lastSuccessfulLogin))
            timeLeft=$((maxSessionDuration - timeSinceLastLogin))

            if ((timeLeft <= fastCheckPrior)); then
                sleepTime=$fastCheckPeriod
            else
                sleepTime=$checkIntervalSeconds
            fi
            echo "$(date): Internet connection is active. Time since last successful login: $timeSinceLastLogin seconds"
        fi
    else
        echo "$(date): Internet connection is down. Attempting to login..."
        loginUrl='https://net2.sharif.edu/login'
        username='yourUsername'  # Replace with your username
        password='yourPassword'  # Replace with your password
        # Send POST request and save HTTP status code to a variable
        httpResponse=$(curl -s -o /dev/null -w "%{http_code}" -X POST -d "username=$username&password=$password" "$loginUrl")
        
        # Check if the HTTP response code is 200 (OK), which we'll assume means login was successful
        if [ "$httpResponse" -eq 200 ]; then
            echo "$(date): Login attempt was successful."
            echo "$currentTime" > "$lastLoginFile"
        else
            echo "$(date): Failed to login. Server responded with status: $httpResponse"
        fi
        sleepTime=$checkIntervalSeconds  # Reset sleepTime after a failed login attempt
    fi

    echo "Next check in $sleepTime seconds."
    sleep $sleepTime
}

# Main loop
while true; do
    test_and_login
done
