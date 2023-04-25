# Module 12: Infrastructure as Code with Terraform

### Demo Project:
Automate AWS Infrastructure

### Technologies used:
Terraform, AWS, Docker, Linux, Git

### Project Description:
- Create TF project to automate provisioning AWS Infrastructure and its components, such as: VPC, Subnet, Route Table, Internet Gateway, EC2, Security Group
- Configure TF script to automate deploying Docker container to EC2 instance
---
### Install Terraform
- install via package manager (ex. homebrew)
- download binary:
    - https://learn.hashicorp.com/tutorials/terraform/install-cli
    - https://www.terraform.io/downloads.html
- install HashiCorp Terraform extension for VS Code

### Overview of simple usecase of Terraform and AWS
1. create a custom VPC
2. inside the VPC, create one custom Subnet in one of the AZs
3. connect VPC to the internet with Internet Gateway (create Route Table and Internet Gateway)
    - need to associate the subnet with the route table, will handle the traffic inside of the subnet
4. inside the Subnet, provision an EC2 instance
5. deploy nginx Docker container on the EC2 instance
6. create a Security Group (firewall), so the app is accessible from the browser and through ssh

### Terraform Manages Infrastructure
- Configured Infrastructure (in main.tf)
    - created AWS infrastructure
    - configured networking
    - provisioned server
- Configuration of provisioned infrastructure (used shell script)
    - installed Docker on server
    - deployed app on server

### Provision AWS Infrastructure
- main.tf: https://github.com/daniellehopedev/terraform-learn/blob/main/terraform-aws-infra/main.tf

### Configure TF Script to Deploy Docker Container to EC2 Instance
- entry-script.sh: https://github.com/daniellehopedev/terraform-learn/blob/main/terraform-aws-infra/entry-script.sh
