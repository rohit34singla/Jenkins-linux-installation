#!/bin/bash

# Exit script on error
set -e

# Update the system and install OpenJDK
echo "Updating system packages..."
if sudo apt update; then
    echo "System packages updated successfully."
else
    echo "Failed to update system packages." >&2
    exit 1
fi

echo "Installing OpenJDK 17..."
if sudo apt install -y openjdk-17-jre; then
    echo "OpenJDK 17 installed successfully."
else
    echo "Failed to install OpenJDK 17." >&2
    exit 1
fi

echo "Verifying Java installation..."
if java -version; then
    echo "Java installed and verified successfully."
else
    echo "Java verification failed." >&2
    exit 1
fi

# Add Jenkins repository key and source list
echo "Adding Jenkins GPG key..."
if curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null; then
    echo "Jenkins GPG key added successfully."
else
    echo "Failed to add Jenkins GPG key." >&2
    exit 1
fi

echo "Adding Jenkins repository..."
if echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null; then
    echo "Jenkins repository added successfully."
else
    echo "Failed to add Jenkins repository." >&2
    exit 1
fi

# Update the system and install Jenkins
echo "Updating system packages after adding Jenkins repository..."
if sudo apt-get update; then
    echo "System packages updated successfully after adding Jenkins repository."
else
    echo "Failed to update system packages after adding Jenkins repository." >&2
    exit 1
fi

echo "Installing Jenkins..."
if sudo apt-get install -y jenkins; then
    echo "Jenkins installed successfully."
else
    echo "Failed to install Jenkins." >&2
    exit 1
fi

# Display the initial admin password
echo "Retrieving the Jenkins initial admin password..."
if sudo cat /var/lib/jenkins/secrets/initialAdminPassword; then
    echo "Jenkins initial admin password retrieved successfully."
else
    echo "Failed to retrieve Jenkins initial admin password." >&2
    exit 1
fi

echo "Jenkins installation and setup completed successfully!"
