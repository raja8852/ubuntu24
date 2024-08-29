#!/bin/bash
sudo apt-get update
sudo apt-get install -y expect

# Define a temporary expect script
expect_script=$(mktemp)

# Create the expect script content
cat <<'EOF' > "$expect_script"
#!/usr/bin/expect -f



# Start the squid-add-user command
spawn squid-add-user

# Debugging information
log_user 1

# Expect the prompt for username
expect "Username:"
send "raja\r"

# Expect the prompt for password
expect "Password:"
send "raja\r"

# Expect the prompt for password
expect "Password:"
send "raja\r"

# Expect the prompt for password
expect "Password:"
send "\r"



# Interact with the command
interact
EOF

# Make the expect script executable
chmod +x "$expect_script"

# Debug output
echo "Starting the installation and configuration process..."

# Elevate to root and execute the commands
sudo bash <<EOF
    echo "Downloading squid3-install.sh..."
    wget https://raw.githubusercontent.com/bosedipankar/squid-proxy-installer/master/squid3-install.sh
    
    echo "Running squid3-install.sh..."
    bash squid3-install.sh
    
    echo "Waiting for 5 seconds..."
    sleep 5
    
    echo "Adding user 'raja'..."
    /usr/bin/expect "$expect_script"
EOF

# Clean up the temporary expect script
rm "$expect_script"
