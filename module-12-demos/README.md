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

---
---

### Demo Project:
Complete CI/CD with Terraform

### Technologies used:
Terraform, Jenkins, Docker, AWS, Git, Java, Maven, Linux, Docker Hub

### Project Description:
Integrate provisioning stage into complete CI/CD Pipeline to automate provisioning server instead of deploying to an existing server
- Create SSH Key Pair
- Install Terraform inside Jenkins container
- Add Terraform configuration to application's git repository
- Adjust Jenkinsfile to add "provision" step to the CI/CD pipeline that provisions EC2 instance
- So the complete CI/CD project we build has the following configuration:
    a. CI step: Build artifact for Java Maven application
    b. CI step: Build and push Docker image to Docker Hub
    c. CD step: Automatically provision EC2 instance using TF
    d. CD step: Deploy new application version on the provisioned EC2 instance with Docker Compose
---
### Create SSH Key Pair
1. in AWS create a key pair and configure credentials in Jenkins from that key pair
    - can also create a public private key with terraform using sshkeygen
2. take generated pem file and create 'SSH Username with private key' credential in Jenkins
    - user is ec2-user and enter the private key directly (the contents of the pem file)

### Install TF Inside Jenkins Container
1. ssh into the container as the root user
    - installation instructions: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

### Add the Terraform configuration files to the java maven application
- terraform directory: https://github.com/daniellehopedev/java-maven-app/tree/feature/terraform-cicd/terraform

### Adjust Jenkinsfile to add provision step
- Updated Jenkinsfile: https://github.com/daniellehopedev/java-maven-app/blob/feature/terraform-cicd/Jenkinsfile
- docker-compose: https://github.com/daniellehopedev/java-maven-app/blob/feature/terraform-cicd/docker-compose.yaml
- dockerfile: https://github.com/daniellehopedev/java-maven-app/blob/feature/terraform-cicd/Dockerfile
- server-cmds: https://github.com/daniellehopedev/java-maven-app/blob/feature/terraform-cicd/server-cmds.sh

---
---

### Demo Project:
Configure a Shared Remote State

### Technologies used:
Terraform, AWS S3

### Project Description:
- Configure Amazon S3 as remote storage for Terraform state
---
### Configure storage for Terraform state
- Problem: each user/CI server must make sure they always have the latest state data before running Terraform
    - How do we share a same Terraform state file?
- Configure a remote state
    - TF writes the data to this remote data store
        - good for data backup
        - can be shared
        - keeps sensitive data off disk
    - Different remote storage options possible

### Configure remote storage in main.tf
- add the below snippet to the top of your main.tf
    - full main.tf: https://github.com/daniellehopedev/java-maven-app/blob/feature/terraform-remote-state/terraform/main.tf
```
terraform {
    required_version = ">= 0.12"
    backend "s3" {
        bucket = "myapp-bucket"
        key = "myapp/state.tfstate"
        region = "us-east-1"
    }
}
```
- create AWS S3 Bucket
    - in AWS, go to Amazon S3 service, and create a bucket
    - good practice to enable Bucket Versioning
- `terraform state list`: will retrieve data from the bucket and give a list of resources created from the remote storage

### Useful links
- Terraform Backends: https://www.terraform.io/docs/backends/
- Remote State: https://www.terraform.io/docs/state/remote.html
- AWS S3: https://aws.amazon.com/s3/