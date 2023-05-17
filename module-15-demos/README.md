# Module 15: Configuration Management with Ansible

## Ansible Setup

### Install Ansible
- installation guide: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
- install command (macos):
    - `brew install ansible`
- ansible is written in python, the installation of python is required
- can also be installed with pip

### Configure Ansible Connection to Remote Servers
- on DigitalOcean, create 2 ubuntu droplets
    - make sure python is installed on those servers
- connect ansible to the two remote servers
    - create hosts file or "inventory" file
        - file containing data about the ansible client servers
        - "hosts" meaning the managed servers
        - default location for file: /etc/ansible/hosts
    - copy the ip addresses of the remote servers to the hosts file
    - for each ip address add `ansible_ssh_private_key_file=<private-key-file-location>`
    - for each ip address add `ansible_user=root`
- test connection using some ansible ad-hoc commands
    - a fast way to interact with the desired servers `ansible [pattern] -m [module] -a "[module options]"`
        - `ansible all -i hosts -m ping`
    - [pattern] = targeting hosts and groups
    - "all" = default group, which contains every host
- Grouping hosts
    - can put each host in more than one group
    - can create groups that track:
        - WHERE - a datacenter/region, e.g. east, west
        - WHAT - e.g. database servers, web servers etc.
        - WHEN - which stage, e.g. dev, test, prod environment
    - at the top of a grouping of ip addresses or servers just put a name `[droplet]` or `[aws]` or `[database]`, depending on what you are using.
    - in this case it would just be `[droplet]`
    - command: `ansible droplet -i hosts -m ping`
- to address a specific server, just give the ip address or host name in the command
- configure credentials and user for a group instead of adding this separately to each ip address if they are the same, in the hosts file
    ```
    [droplet:vars]
    ansible_ssh_private_key_file=
    ansible_user=
    ```

---

### Demo Project:
Automate Node.js application deployment

### Technologies used:
Ansible, Node.js, DigitalOcean, Linux

### Project Description:
- Create server on DigitalOcean
- Write Ansible Playbook that installs necessary technologies, creates Linux user for an application and deploys a NodeJS application with that user
---

---
---

### Demo Project:
Automate Nexus Deployment

### Technologies used:
Ansible, Nexus, DigitalOcean, Java, Linux

### Project Description:
- Create server on DigitalOcean
- Write Ansible Playbook that creates Linux user for Nexus, configure server, installs and deploys Nexus and verifies that it is running successfully
---

---
---

### Demo Project:
Ansible & Docker

### Technologies used:
Ansible, AWS, Docker, Terraform, Linux

### Project Description:
- Create AWS EC2 Instance with Terraform
- Write Ansible Playbook that installs necessary technologies like Docker and Docker Compose, copies docker-compose file to the server and starts the Docker containers configured inside the docker-compose file
---

---
---

### Demo Project:
Ansible Integration in Terraform

### Technologies used:
Ansible, Terraform, AWS, Docker, Linux

### Project Description:
- Create Ansible Playbook for Terraform integration
- Adjust Terraform configuration to execute Ansible Playbook automatically, so once Terraform provisions a server, it executes an Ansible playbook that configures the server
---

---
---

### Demo Project:
Configure Dynamic Inventory

### Technologies used:
Ansible, Terraform, AWS

### Project Description:
- Create EC2 Instance with Terraform
- Write Ansible AWS EC2 Plugin to dynamically set inventory of EC2 servers that Ansible should manage, instead of hard-coding server addresses in Ansible inventory file
---

---
---

### Demo Project:
Ansible Kubernetes Deployment

### Technologies used:
Ansible, Terraform, Kubernetes, AWS EKS, Python, Linux

### Project Description:
- Create EKS cluster with Terraform
- Write Ansible Play to deploy application in a new K8s namespace
---

---
---

### Demo Project:
Ansible Integration in Jenkins

### Technologies used:
Ansible, Jenkins, DigitalOcean, AWS, Boto3, Docker, Java, Maven, Linux, Git

### Project Description:
- Create and configure a dedicated server for Jenkins
- Create and configure a dedicated server for Ansible Control Node
- Write Ansible Playbook, which configures 2 EC2 Instances
- Add ssh key file credentials in Jenkins for Ansible Control Node server and Ansible Managed Node servers
- Configure Jenkins to execute the Ansible Playbook on remote Ansible Control Node server as part of the CI/CD pipeline
- So the Jenkinsfile configuration will do the following:
    1. Connect to the remote Ansible Control Node server
    2. Copy Ansible playbook and configuration files to the remote Ansible Control Node server
    3. Copy the ssh keys for the Ansible Managed Node servers to the Ansible Control Node server
    4. Install Ansible, Python3 and Boto3 on the Ansible Control Node server
    5. With everything installed and copied to the remote Ansible Control Node server, execute the playbook remotely on that Control Node that will configure the 2 EC2 Managed Nodes
---

---
---

### Demo Project:
Structure Playbooks with Ansible Roles

### Technologies used:
Ansible, Docker, AWS, Linux

### Project Description:
- Break up large Ansible Playbooks into smaller manageable files using Ansible Roles
---