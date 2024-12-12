
#!/bin/bash

# Usage help
function usage() {
  echo "Usage: $0 [open|check|close] PORT"
  exit 1
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Check for arguments
if [[ $# -ne 2 ]]; then
  usage
fi

ACTION=$1
PORT=$2

# Function to open port
function open_port() {
  echo "Opening port $PORT..."
  firewall-cmd --add-port=$PORT/tcp --permanent
  firewall-cmd --reload
  echo "Port $PORT opened."
}

# Function to check port status
function check_port() {
  echo "Checking port $PORT..."
  firewall-cmd --list-ports | grep -q "$PORT/tcp"
  if [[ $? -eq 0 ]]; then
    echo "Port $PORT is open."
  else
    echo "Port $PORT is closed."
  fi
}

# Function to close port
function close_port() {
  echo "Closing port $PORT..."
  firewall-cmd --remove-port=$PORT/tcp --permanent
  firewall-cmd --reload
  echo "Port $PORT closed."
}

# Perform the requested action
case $ACTION in
  open)
    open_port
    ;;
  check)
    check_port
    ;;
  close)
    close_port
    ;;
  *)
    usage
    ;;
esac
