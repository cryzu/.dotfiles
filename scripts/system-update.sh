#!/bin/bash

set -e

green='\033[1;32m'
yellow='\033[1;33m'
cyan='\033[1;36m'
red='\033[1;31m'
reset='\033[0m'

echo -e "${yellow}Requesting sudo access...${reset}"

# Ask for sudo password once, before doing anything
sudo -v

# Keep sudo credentials alive while this script is running
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" 2>/dev/null || exit
done 2>/dev/null &
KEEPALIVE_PID=$!

cleanup() {
    kill "$KEEPALIVE_PID" 2>/dev/null || true
}
trap cleanup EXIT

echo
echo -e "${yellow}Creating rollback snapshot...${reset}"

sudo snapper -c Timelined create \
    -d "Package update rollback" \
    -c number

echo -e "${green}✓ Snapshot created.${reset}"

echo
echo -e "${yellow}Updating packages...${reset}"

yay

echo -e "${green}✓ Package update complete.${reset}"

echo
echo -e "${yellow}Updating Limine...${reset}"

sudo limine-update

echo -e "${green}✓ Limine updated.${reset}"

echo
echo -e "${cyan}Done - press Enter to exit.${reset}"
read