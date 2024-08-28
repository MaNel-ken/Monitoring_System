# Monitoring_System
1. Install terraform in win/linux

2. Install virtualbox 

3. Add VirtualBox path 

4. Provision VMs:
```bash
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
```

5. Allow ssh to VMs:
- Some server providers, such as Amazon EC2 and Google Compute Engine, Vagrant disable SSH password authentication by default. 
That is, you can only log in over SSH using public key authentication which mean You have to add the public key manually to the remote server.

- To enable SSH password authentication, you must SSH in as root to edit this file: /etc/ssh/sshd_config 
```bash
$ sudo -i 
```
- Then, change the line \

`PasswordAuthentication no`    to      `PasswordAuthentication yes`

and the line \

`#PubkeyAuthentication yes` to `PubkeyAuthentication yes`

- After making that change, restart the SSH service by running the following command as root:
```bash
$ sudo service ssh restart
```

6. Install Python in the 2nd  VM:
```bash
$ sudo apt install python -y
```

7. Install Ansible in the 1st VM:
```bash
$ ./setup_ansible.sh
```

8. Apply ansible playbook to install necesary packages in the other VM:
```bash
$ ansible-playbook  package_instal_compose_node.yml -i inventory -u vagrant --ask-pass
```

9. Run docker compose services:
```bash
$ mkdir monitoring-system
$ docker compose up -d
```