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
### Create DigitalOcean Server
1. start up a small ubuntu server on DigitalOcean
2. create hosts file to setup connection for ansible

### Playbook
1. simple node application for demo: https://github.com/daniellehopedev/simple-nodejs
2. deploy-node.yaml: https://github.com/daniellehopedev/ansible-learn/blob/main/deploy-node.yaml
- useful modules:
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/unarchive_module.html#
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html
    - https://docs.ansible.com/ansible/latest/collections/community/general/npm_module.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html
    - https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_async.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/debug_module.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html

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
### Create DigitalOcean Server
1. start up a small ubuntu server on DigitalOcean
2. make sure to copy the ip address to the hosts file

### Playbook
1. deploy-nexus.yaml: https://github.com/daniellehopedev/ansible-learn/blob/main/deploy-nexus.yaml
2. nexus.sh - shell script for reference: https://github.com/daniellehopedev/ansible-learn/blob/main/nexus.sh
-  useful modules:
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/get_url_module.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/find_module.html
    - https://docs.ansible.com/ansible/2.10/collections/ansible/builtin/stat_module.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/group_module.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/blockinfile_module.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lineinfile_module.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/pause_module.html
- conditionals: 
    - https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html

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
### Create EC2 Instance
1. Terraform script to create EC2 instance
    - https://github.com/daniellehopedev/terraform-learn/tree/feature/ansible-ec2
2. Script for installing docker-compose for reference
    - https://github.com/daniellehopedev/java-maven-app/blob/feature/terraform-remote-state/terraform/entry-script.sh

### Playbook
1. deploy-docker-ec2-user.yaml: https://github.com/daniellehopedev/ansible-learn/blob/main/deploy-docker-ec2-user.yaml
- useful modules:
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/yum_module.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/pipe_lookup.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/systemd_module.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/meta_module.html
    - https://docs.ansible.com/ansible/latest/collections/community/docker/docker_image_module.html
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/pip_module.html
    - https://docs.ansible.com/ansible/latest/collections/community/docker/docker_login_module.html
    - https://docs.ansible.com/ansible/latest/collections/community/docker/docker_compose_module.html
- interactive prompts:
    - https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_prompts.html

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
### Ansible Playbook
1. deploy-docker-ec2-user.yaml: https://github.com/daniellehopedev/ansible-learn/blob/main/deploy-docker-ec2-user.yaml
2. updated terraform config: https://github.com/daniellehopedev/terraform-learn/blob/feature/ansible-ec2/terraform-aws-infra/main.tf
- useful modules:
    - https://docs.ansible.com/ansible/latest/collections/ansible/builtin/wait_for_module.html
- provisioners:
    - https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax
- null_resource:
    - https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource

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
### Create EC2 Instance with Terraform
1. Terraform config: https://github.com/daniellehopedev/terraform-learn/blob/main/terraform-python-automation/main.tf
    - can remove the user_data here, since we don't need to configure anything on the server
    - update the configuration, in the vpc resource
        - add `enable_dns_hostnames = true` to assign public dns to the ec2 instances
- Dynamic Inventory: https://docs.ansible.com/ansible/latest/inventory_guide/intro_dynamic_inventory.html
- Inventory Plugins: https://docs.ansible.com/ansible/latest/plugins/inventory.html#inventory-plugins
- EC2 Inventory Source: https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ec2_inventory.html
- Ansible Inventory command: https://docs.ansible.com/ansible/latest/cli/ansible-inventory.html

### Ansible Playbook
1. ansible.cfg (enable ec2 plugin): https://github.com/daniellehopedev/ansible-learn/blob/main/ansible.cfg
2. in the playbook, update all the 'hosts' attributes to 'aws_ec2'
3. setup ssh credentials for login to the remote servers
    - add `remote_user = ec2_user` and `private_key_file = <path-to-ssh-key>` to the ansible cfg file
4. inventory_aws_ec2.yaml: https://github.com/daniellehopedev/ansible-learn/blob/main/inventory_aws_ec2.yaml
    - ansible-inventory cmd: `ansible-inventory -i inventory_aws_ec2.yaml --list`
        - lists all the data fetched from aws about your servers
        - contains list of host names
        - `--graph` will give you a cleaner output of the dns names (shows the private dns names)
        - if there are no public dns names assigned, the private dns names will be listed
5. ansible-playbook command: `ansible-playbook -i inventory_aws_ec2.yaml <ansible-playbook>`
    - will use inventory_aws_ec2.yaml to get the host/dns names dynamically instead of hardcoding them in the hosts file

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