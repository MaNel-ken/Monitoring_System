# Monitoring System
This project demonstrates a DevOps monitoring system that leverages Terraform, Ansible, and Docker Compose to automate the deployment of monitoring services such as Prometheus, Grafana, and Alertmanager. The system is designed to monitor a sample NGINX application and provide real-time insights into its performance.

## Prerequisites
Before setting up the monitoring system, ensure the following tools are installed on your local machine:

- Terraform: Used to provision virtual machines (VMs).
- VirtualBox: Hypervisor for running the VMs.
- Add VirtualBox path in OS
- Git: For cloning the repository.

## Step 1: Provision VMs using Terraform
- Clone the Repository:
```bash
$ git clone https://github.com/your-repo/monitoring-system.git
$ cd Monitoring_System
```
- Initialize and apply terrafrom configuration:
```bash
$ cd terraform
$ terraform init
$ terraform plan # to Review the Terraform plan
$ terraform apply --auto-approve # Apply the Terraform configuration to provision the VMs 
```
> This step provisions two VMs: one as the Ansible controller and another for hosting the monitoring system.


## Step 2: Apply Ansible Playbooks
- Install Ansible in the 1st VM:
```bash
$ cd ../ansible
$ ./setup_ansible.sh
```
- Update the Inventory File:
```bash
[DockerCompose]
node ansible_host= ip_address_MS_VM
```
Add the IP addresses of the VMs under the [DockerCompose] section.
- Run the Ansible playbook to install necessary packages in the other VM:
```bash
$ ansible-playbook  package_instal_compose_node.yml -i inventory -u vagrant --ask-pass
```
## Step 3: Deploy Monitoring Services with Docker Compose
- SSH into the monitoring VM:
```bash
$ ssh vagrant@monitoring_vm_ip 
```
- Run docker compose services:
```bash
$ cd ../monitoring-system
$ docker compose up -d
```
> This command will start Prometheus, Grafana, Alertmanager, and the sample NGINX application.

## Verification and Testing
Access Grafana: Navigate to http://<monitoring_vm_ip>:3000 to access Grafana and log in with the default credentials. 

View Prometheus Metrics: Visit http://<monitoring_vm_ip>:9090 to access Prometheus and explore the metrics collected.

Test Alerts: Configure alert rules in Prometheus and verify that alerts are being sent to Alertmanager.

## Troubleshooting
Issue: can't ssh to the VM 

Solution: Allow ssh to VMs
- Some server providers, such as Amazon EC2 and Google Compute Engine, Vagrant disable SSH password authentication by default. 
That is, you can only log in over SSH using public key authentication, which mean You have to add the public key manually to the remote server.

- To enable SSH password authentication, you must SSH in as root to edit this file: /etc/ssh/sshd_config 
```bash
$ sudo -i 
```
- Then, change the line 

`PasswordAuthentication no`    to      `PasswordAuthentication yes`

and the line 

`#PubkeyAuthentication yes` to `PubkeyAuthentication yes`

- After making that change, restart the SSH service by running the following command as root:
```bash
$ sudo service ssh restart
```

Issue: Can't apply Ansible playbook\
[ERROR]:  {"changed": false, "module_stderr": "Shared connection to localhost closed.\r\n", "module_stdout": "/bin/sh: 1: /usr/bin/python: not found\r\n", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 127}

Solution: Install Python in the 2nd  VM:
```bash
$ sudo apt install python -y
```
Issue: Docker Compose services fail to start.

Solution: Check Docker logs using docker-compose logs to diagnose the issue.

Issue: Unable to access Grafana or Prometheus.

Solution: Verify that the firewall rules allow access to the required ports (3000 for Grafana, 9090 for Prometheus).

## Customization
Add New Services: Modify the docker-compose.yml file to include additional services or exporters as needed.

Update Alert Rules: Customize alert rules in Prometheus by editing the prometheus.yml configuration file.
