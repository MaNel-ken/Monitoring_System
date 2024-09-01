# Monitoring System
This project demonstrates a DevOps monitoring system that leverages Terraform, Ansible, and Docker Compose to automate the deployment of monitoring services such as Prometheus, Grafana, and Alertmanager. The system is designed to monitor a sample NGINX application and provide real-time insights into its performance.

## Prerequisites
Before setting up the monitoring system, ensure the following tools are installed on your local machine:

- Terraform: Used to provision virtual machines (VMs).
- VirtualBox: Hypervisor for running the VMs.
> Ensure the VirtualBox path is added to your system's environment variables.
- Git: For cloning the repository.

## Step 1: Provision VMs using Terraform
- Copy the Terraform Files:\
Copy the main.tf file from the Terraform directory to your local machine.

- Initialize and apply terrafrom configuration:
```bash
$ cd terraform
$ terraform init
$ terraform plan # to Review the Terraform plan
$ terraform apply --auto-approve # Apply the Terraform configuration to provision the VMs 
```
> This step provisions two VMs: one as the Ansible controller and another for hosting the monitoring system.


## Step 2: Apply Ansible Playbooks
- Clone the Repository:
```bash
$ git clone https://github.com/your-repo/monitoring-system.git
$ cd Monitoring_System
```
- Install Ansible on the 1st VM:
```bash
$ cd ansible
$ ./setup_ansible.sh
```
- Update the Inventory File: Modify the inventory file to include the IP address of the monitoring system VM.
```bash
[DockerCompose]
node ansible_host= <ip_address_MS_VM>
```
- Run the Ansible playbook to install necessary packages on the other VM:
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
$ cd monitoring-system
$ docker compose up -d
```
> This command will start Prometheus, Grafana, Alertmanager, and the sample NGINX server.

## Verification and Testing
1. Access Grafana: 
- Navigate to http://<monitoring_vm_ip>:3000 to access Grafana and log in with the default credentials (`admin`:`admin`). 

![alt text]()

- Once logged in, you will see two pre-configured dashboards that were mounted in the dashboard directory when the container was created.

![alt text]()

2. View Prometheus Metrics: 
- Visit http://<monitoring_vm_ip>:9090 to access Prometheus and explore the metrics collected:
![alt text]()

- Review the targets and alerts that have been configured.

![alt text]()

![alt text]()

3. View Nginx webpage:
Visit http://<monitoring_vm_ip>:80 to access Nginx webpage.

![alt text]()

4. Test Alerts: 
- To test the alerting system, you can trigger an alert by stopping the NGINX instance. This will cause Prometheus to fire an alert after 1 minute and notify Alertmanager.

```bash
$ docker compose pause nginx
```
- Pending status of the alert:
![alt text]()

- After 1min, Firing status:
![alt text]()

- Alertmanager Receiving the Alert:
![alt text]()

- Webhook Notification:
![alt text]()

- Grafana Dashboard Update:
![alt text]()

## Troubleshooting
### Issue: Can't ssh to the VM
**Symptoms:**
- Unable to establish an SSH connection to the VM.
- Receiving an "Authentication failed" error.

**Cause:**
- Some server providers, such as Amazon EC2 and Google Compute Engine, Vagrant disable SSH password authentication by default. 
That is, you can only log in over SSH using public key authentication, which mean You have to add the public key manually to the remote server.

**Solution:** Allow ssh to VMs
1. Log in as root user:
```bash
$ sudo -i 
```
2. Edit the SSH configuration file:
```bash
$ nano /etc/ssh/sshd_config
```
3. Change the following lines: 
-  `PasswordAuthentication no`    to      `PasswordAuthentication yes`
- `#PubkeyAuthentication yes` to `PubkeyAuthentication yes`

4. Save the changes and Restart the SSH service:
```bash
$ sudo service ssh restart
```
---

### Issue: Can't apply Ansible playbook
**Symptoms:**
- Error message when running an Ansible playbook:  {"changed": false, "module_stderr": "Shared connection to localhost closed.\r\n", "module_stdout": "/bin/sh: 1: /usr/bin/python: not found\r\n", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 127}

**Cause:**
- Python is not installed on the remote VM. Ansible relies on Python to execute tasks on the remote machine.

**Solution:** Install Python on the remote VM
1. Install python :
```bash
$ sudo apt install python -y
```
2. Re-run the Ansible playbook.
---
### Issue: Docker Compose services fail to start.
**Symptoms:**
- Docker Compose services are not running or crash immediately after starting.

**Cause:**
- The root cause can vary, such as misconfigured Docker Compose files, missing environment variables, or issues within the Docker images themselves.

**Solution:** Check Docker logs using docker-compose logs to diagnose the issue.
1. Use Docker Compose to view logs and diagnose the issue:
```bash
$ docker-compose logs
```
2. Identify any error messages or issues within the logs and take appropriate action, such as correcting configuration files or resolving dependency issues.

## Customization

### Add New Services
To add additional services or exporters, modify the `docker-compose.yml` file. 

### Update Alert Rules
Customize Prometheus alert rules by editing the `alertrules.yml` configuration file located in the `prometheus` directory.

### Add alert Receivers 
Customize additional alert receivers in Alertmanager by editing the `alertmanager.yml` file located in the `alertmanager` directory.

### Add Grafana Dashboards
To permanently add a new Grafana dashboard, place the corresponding JSON file in the monitoring-system-compose/grafana/dashboards/ directory. Alternatively, you can import a dashboard temporarily (until the service reboots) through the Grafana UI.

