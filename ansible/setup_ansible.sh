#!/bin/bash

#cd Ansible

# ---------------------- Set up SSH Passwordless communication between Ansible controller and remote nodes ------
# Step 1: Check if Ansible is installed, if not, install it
echo -e "\n-Step 1: Checking if Ansible is installed..."
if ! command -v ansible &> /dev/null
then
    echo -e " --> Ansible is not installed. Installing Ansible and sshpass..."
    sudo apt update
    sudo apt install software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install ansible sshpass -y
else
    echo -e " --> Ansible is already installed."
fi


# Step 2: Create ansible.conf
echo -e "\n-Step 2: Creating ansible.conf..."
cat <<EOL > ansible.cfg

[defaults]
inventory = inventory
remote_user = vagrant
host_key_checking = False

EOL
cat ansible.cfg

# Step 3: Testing connectivity to the servers
echo -e "\n-Step 3: Testing connectivity to the remote nodes..."
ansible all -m ping -i inventory -u vagrant




