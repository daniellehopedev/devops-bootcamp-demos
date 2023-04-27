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

---
---

### Demo Project:
Modularize Project

### Technologies used:
Terraform, AWS, Docker, Linux, Git

### Project Description:
- Divide Terraform resources into reusable modules
---
### Modules
- container for multiple resources, used together
- can create modules and/or use existing modules
- https://developer.hashicorp.com/terraform/tutorials/modules/module

### Why Modules?
- organize and group configurations
- encapsulate into distinct logical components
- re-use
- customize the configuration with variables
- expose created resources or specific attributes

### Best Practice - Project Structure
- Files
    - main.tf
    - variables.tf
    - outputs.tf
    - providers.tf
- modules folder
    - root module
    - /modules = "child modules" - a module that is called by another configuration
- run `terraform init` whenever a module is added or changed

### Modularized AWS Infrastructure Configuration Repo
- Repo: https://github.com/daniellehopedev/terraform-learn/tree/feature/modules/terraform-aws-infra

---
---

### Demo Project:
Terraform & AWS EKS

### Technologies used:
Terraform, AWS EKS, Docker, Linux, Git

### Project Description:
- Automate provisioning EKS cluster with Terraform
---
### Terraform Module for VPC
- https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
- vpc.tf: https://github.com/daniellehopedev/terraform-learn/blob/feature/eks/terraform-aws-infra/vpc.tf

### Terraform Module for EKS
- https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
- eks-cluster.tf: https://github.com/daniellehopedev/terraform-learn/blob/feature/eks/terraform-aws-infra/eks-cluster.tf