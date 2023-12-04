# Function to check if the link is down
check_link_down() {
    link_status=$(sudo ip link show dev eth1 | grep "state DOWN")
    if [ -n "$link_status" ]; then
        echo "Link is down."
    else
        echo "Link is up. Exiting."
        exit 1
    fi
}
# Function to check if the MAC address is set correctly
check_mac_address() {
    current_mac=$(sudo ip link show dev eth1 | awk '/link\/eth/ {print $2}')
    expected_mac="12:34:56:1a:2b:3c"

    if [ "$current_mac" = "$expected_mac" ]; then
        echo "MAC address is set correctly."
    else
        echo "MAC address is not set correctly. Exiting."
        exit 1
    fi
}

# Disable the network interface
sudo ip link set dev eth1 down
check_link_down

# Set the new MAC address
sudo ip link set dev eth1 address 12:34:56:1A:2B:3C
check_mac_address

# Enable the network interface
sudo ip link set dev eth1 up
check_link_down  # Check again after bringing the interface up
 ip link set dev eth1 up