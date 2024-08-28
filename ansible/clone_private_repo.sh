#!/bin/bash

# ------------------ GitHub Personal Access Token for authentication ------------------
token="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"

#  ------------------ generate Ssh key for accessing Github  ------------------
echo "1. Generating ssh key for accessing Github if it doesn't exist..."
# Check if the SSH key file exists
if [ ! -f "/home/vagrant/.ssh/id_rsa_git" ]; then
    # Generate SSH key for accessing GitHub
    ssh-keygen -t rsa -f  /home/vagrant/.ssh/id_rsa_git  -N ''
fi

#  ------------------ Read the public key content ------------------
content=$(cat /home/vagrant/.ssh/id_rsa_git.pub)

#  ------------------ Add the SSH key to the GitHub account using the GitHub API  ------------------
echo -e "\n2. Adding SSH key to GitHub..."
curl -H "Authorization: token $token" --data '{"title":"test-key","key":"'"$content"'"}' https://api.github.com/user/keys

#  ------------------ Check if the GitHub host key is already in the known_hosts file  ------------------
echo -e "\n3. Checking GitHub host key in known_hosts..."
if ! grep -q "github.com" ~/.ssh/known_hosts; then
  # If not present, fetch and add the GitHub host key to the known_hosts file
  echo -e "\n --> Fetching and adding GitHub host key to known_hosts..."
  ssh-keyscan -T 10 github.com >>  ~/.ssh/known_hosts
fi

# ------------------ Start the ssh-agent and add the SSH private key to it ------------------
echo -e "\n4. Starting ssh-agent and adding SSH key..."
eval $(ssh-agent -s)
ssh-add  ~/.ssh/id_rsa_git


# ------------------ Set up variables for Git operations ------------------
KEY_PATH="~/.ssh/known_hosts"
GIT_EXECUTABLE="/usr/bin/git"
GIT_REPO="git@github.com:MaNel-ken/Monitoring_System.git"
CLONE_DEST="/home/vagrant/Monitoring_System"

# ------------------ Clone the Git repository using the specified SSH key and other options ------------------
echo -e "\n5. Cloning Git repository..."
GIT_SSH_COMMAND="ssh -i $KEY_PATH -v -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" $GIT_EXECUTABLE clone $GIT_REPO $CLONE_DEST

# ------------------ Kill the ssh-agent ------------------
echo -e "\n6. Killing ssh-agent..."
pid=$(ps -A | grep ssh-agent | awk 'NR==1{print $1}' | cut -d' ' -f1)
kill $pid

# ------------------ Navigate to the 'Monitoring_System' directory  ------------------
echo -e "\n7. Navigate to the Monitoring_System directory "
cd Monitoring_System