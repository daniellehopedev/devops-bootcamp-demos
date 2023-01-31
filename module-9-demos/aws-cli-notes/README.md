# Module 9: AWS Services

### Demo Project:
Interacting with AWS CLI

### Technologies Used:
AWS, Linux

### Project Description:
- Install and configure AWS CLI tool to connect to your AWS account
- Create EC2 Instance using the AWS CLI with all necessary configurations like Security Group
- Create SSH key pair
- Create IAM resources like User, Group, Policy using the AWS CLI
- List and browse AWS resources using the AWS CLI
---
### Install and configure AWS CLI tool
1. for mac os, `brew updated` then `brew install awscli` or use instructions in the official documentation
    - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
2. connect aws cli to aws account
    - `aws configure`
    - follow the prompts to set up access key id and secret access key
        - copy the access key id and secret access key from the credential information of the aws user account that is created in the aws console
        - for default region, enter a region from the region dropdown in the aws console
            - this will be the default region that is used for the executed commands
                - ex. the command to create an ec2 instance, that instance will be created in this default region
        - for default output, can enter 'json' 
            - this is for whenever you execute commands, the output of the commands will be displayed in the declared format
    - the configuration information will be located in your home directory in .aws/ directory
        - will see config and credentials files
3. command structure: `aws <command> <subcommand> [options and parameters]`
    - aws = the base call to the aws program
    - command = the aws service
    - subcommand = specifies which operation to perform

### Usefull commands to know to achieve the following:
1. aws cli examples: https://github.com/daniellehopedev/devops-bootcamp-demos/blob/main/module-9-demos/aws-cli-notes/aws-cli-commands.sh
