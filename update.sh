#!/bin/bash

echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo -e "Updating Linux... Please Wait..."
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

# Function to prompt for and provide user input when needed
provide_input() {
    while true; do
        # Check if any process is waiting for input
        if read -t 0; then
            # Read the prompt
            read -r prompt
            echo -e "\nPrompt detected: $prompt"
            # Show prompt to user
            read -p "$prompt (Y/n): " user_input
            # Send the response
            echo "$user_input"
        else
            # No process waiting for input, sleep briefly
            sleep 0.1
            break
        fi
    done
}

echo -e "Running 'sudo apt update'... Please Wait..."
# Run commands in background and provide input if needed
sudo apt update 2>&1 | while read -r line; do
    if [[ "$line" =~ [Y/n] ]]; then
        provide_input
    else
        echo "$line" >/dev/null
    fi
done &
wait
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

echo -e "Running 'sudo apt upgrade -y'... Please Wait..."
sudo apt upgrade -y >/dev/null 2>&1 &
wait
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

echo -e "Running 'sudo apt autoremove -y'... Please Wait..."
sudo apt autoremove -y >/dev/null 2>&1 &
wait
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

echo -e "Running 'sudo apt list --upgradable'... Please Wait..."
echo -e "**If any items display below, you will need to manually update them"
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
sudo apt list --upgradable
echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

echo -e "\nUpdate Finished"
echo -e "\nPress Any Key To Exit..."
read -n 1 -s