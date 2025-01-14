#!/bin/bash

#cd Ansible

# ---------------------- Set up SSH Passwordless communication between Ansible controller and remote nodes ------
# Step 1: Check if Ansible is installed, if not, install it
echo -e "\n-Step 1: Checking if Ansible is installed..."
if ! command -v ansible &> /dev/null
then
    echo -e "\n-Ansible is not installed. Installing Ansible and sshpass..."
    sudo apt update
    sudo apt install software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install ansible sshpass -y
else
    echo -e "\n-Ansible is already installed."
fi


# Step 2: Create ansible.conf
echo -e "\n-Step 2: Creating ansible.conf..."
cat <<EOL > ansible.cfg
[defaults]
inventory = inventory
remote_user = vagrant
host_key_checking = False
EOL

# Step 3: Check if SSH keys exist, and generate if not
echo -e "\n-Step 3: Generating SSH keys..."

# Check if the private key already exists
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
  # If the file does not exist, generate the SSH key pair
  ssh-keygen -t rsa -f "$HOME/.ssh/id_rsa" -N ''
  echo "- SSH keys generated successfully."
else
  # If the file exists, print a message
  echo "- SSH keys already exist."
fi

#sudo useradd -m -s /bin/bash vagrant
#echo "vagrant:manel159" | sudo chpasswd
#su vagrant #(enter password)
#mkdir -p /home/vagrant/.ssh
#chmod 700 /home/vagrant/.ssh

# Step 4: Exchange Ansible ssh public key with remote nodes to enable SSH Passwordless communication
echo -e "\n-Step 4: Exchanging Ansible ssh public key with remote nodes..."
ansible-playbook exchange-keys-playbook.yml -i inventory -u vagrant --ask-pass

# Step 5: Testing connectivity to the servers
echo -e "\n-Step 5: Testing connectivity to the remote nodes..."
ansible all -m ping -i inventory -u vagrant




