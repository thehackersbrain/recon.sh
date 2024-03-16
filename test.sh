#!/bin/bash

GRNB='\e[1;32m' # Define colors if you haven't already
RST='\e[0m'
UDL="\e[4m"
ITL="\e[3m"

# echo -e "[${GRNB}+${RST}] Starting Enumerating..."

# Log the start time for the first command
# echo "[$(date +'%Y-%m-%d %H:%M:%S')] Starting the first command..."

# Start the first sleep command
# (sleep 5; echo "[$(date +'%Y-%m-%d %H:%M:%S')] The first command has finished.") &  # This will run for 5 seconds in the background

# Log the start time for the second command
# echo "[$(date +'%Y-%m-%d %H:%M:%S')] Starting the second command..."

# Start the second sleep command
# (sleep 3; echo "[$(date +'%Y-%m-%d %H:%M:%S')] The second command has finished.") &  # This will run for 3 seconds in the background

# Wait for the first sleep command to finish
# wait %1

# Wait for the second sleep command to finish
# wait %2

# Now continue executing the rest of the script
# echo 'this comes later'

# Get the width of the terminal window
# width=$(tput cols)

# Calculate the position for "something2" based on terminal width and length of "something2"
# position=$((width - 10)) # Adjust 10 as per your requirement

# Print "Starting something1"
# echo -n "Starting something1"

# Move cursor to the rightmost side of the screen
# echo -ne "\e[${position}G"

# Print "something2" at the rightmost side
# echo "something2"

# Function to log time and message
# log_msg() {
#     if 
#     local left_text="$1"
#     local width=$(tput cols)
#     local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
#     local position=$((width - 14))  # Adjust this based on your requirement

    # Print timestamp and left text
    # echo -n "[$timestamp] $left_text"

    # Move cursor to the rightmost side of the screen
    # echo -ne "\e[${position}G"

    # Print "completed" at the rightmost side
    # echo -e "${UDL}scan completed${RST}"
# }

# Example usage of the function
# log_msg "Starting something1"
log_msg() {
    local left_text="$1"
    local right_text="$2"
    local log_type="$3"
    local width=$(tput cols)
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    local position=$((width - ${#right_text}))

    # checking for the log type
    case "$log_type" in
      0) color_code='\e[4;32m' ;; # Green
      1) color_code='\e[4;33m' ;; # Yellow
      2) color_code='\e[4;31m' ;; # Red
      *) color_code='\e[0;0m'  ;; # No color
    esac

    # Print timestamp and left text
    echo -ne "[$timestamp] ${GRNB}$0${RST} - [${ITL}$left_text${RST}]"

    # Move cursor to the rightmost side of the screen
    echo -ne "\e[${position}G"

    # Print right text at the rightmost side with underlining
    echo -e "${UDL}${color_code}${right_text}${RST}"
}

# Example usage of the function
log_msg "Amass" "Scan completed" 0
log_msg "Amass" "Scan started" 1
log_msg "Amass" "Scan failed" 2
