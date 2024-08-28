#!/bin/bash

#cd Ansible

# ---------------------- Set up SSH Passwordless communication between Ansible controller and remote nodes ------
# Step 1: Update the system then Install ssh password and ansible
echo -e "\n-Step 1: Update the system..."
sudo apt update
echo -e "\n- Installing sshpass..."
sudo apt install ansible sshpass -y

# Step 2:  Disable host key checking
echo -e "\n-Step 2: Disable host key checking..."
grep -q -F 'host_key_checking = false' /etc/ansible/ansible.cfg  || sudo sed -i '/^\[defaults\]/a host_key_checking = false' /etc/ansible/ansible.cfg

# Step 3: Generate SSH keys
echo -e "\n-Step 3: Generating SSH keys..."
ssh-keygen -t rsa -f  /home/vagrant/.ssh/id_rsa  -N ''

# Step 4: Exchange Ansible ssh public key with remote nodes to enable SSH Passwordless communication
echo -e "\n-Step 4: Exchanging Ansible ssh public key with remote nodes..."
ansible-playbook exchange-keys-playbook.yml -i inventory -u vagrant --ask-pass

# Step 5: Testing connectivity to the servers
echo -e "\n-Step 5: Testing connectivity to the remote nodes..."
ansible all -m ping -i inventory

#--------------------  Packages installation in k8s nodes and mec  -----------------------
# Step 6: Run playbook which Installing Necessary Packages on Kubernetes Nodes
#echo -e "\n-Step 6: Installing Necessary Packages on Kubernetes Nodes..."
#ansible-playbook package_instal_compose_node.yml  -i inventory -u vagrant



