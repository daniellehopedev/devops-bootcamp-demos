# Module 14: Automation with Python

### Demo Project:
Health Check: EC2 Status Checks

### Technologies used:
Python, Boto3, AWS, Terraform

### Project Description:
- Create EC2 Instances with Terraform
- Write a Python script that fetches statuses of EC2 Instances and prints to the console
- Extend the Python script to continuously check the status of EC2 Instances in a specific interval
---
### Install Boto3
- Boto3: AWS SKD for Python
- docs:
    - https://pypi.org/project/boto3/
    - https://boto3.amazonaws.com/v1/documentation/api/latest/index.html
- connect and authenticate with AWS
    - all you need is the .aws directory with the config and credentials files
    - make sure to have secret key-pair, default region, and output format set
    - boto will automatically take the credentials and default region to connect to AWS and authenticate

### Terraform Infrastructure Provisioning vs Python
- Terraform manages state of the infrastructure
    - TF knows the current state
    - TF knows the difference of current state and your configured/desired state
    - TF is idempotent: multiple execution of same config file, will always result in the same end result
    - you declare the end result
- Python
    - doesn't have a state
    - is not idempotent
    - need to explicitly write code to delete resources
- Why use Python Boto3?
    - can do more things because of its low-level API
    - more complex logic is possible
    - python is a programming language and has lots of libraries
    - boto is a aws library
    - can implement monitoring, backups, scheduled tasks, can add web interface

### Create 3 EC2 Instances
- TF configuration: https://github.com/daniellehopedev/terraform-learn/tree/main/terraform-python-automation

### Python Script
- ec2-status-checks.py: https://github.com/daniellehopedev/python-automation/blob/main/ec2-status-checks.py

---
---

### Demo Project:
Automate configuring EC2 Server Instances

### Technologies used:
Python, Boto3, AWS

### Project Description:
- Write a Python script that automates adding environment tags to all EC2 Server Instances
---
### Python Script:
- add-env-tags.py: https://github.com/daniellehopedev/python-automation/blob/main/add-env-tags.py

---
---

### Demo Project:
Automate displaying EKS cluster information

### Technologies used:
Python, Boto3, AWS EKS

### Project Description:
- Write a Python script that fetches and displays EKS cluster status and information
---
### Create EKS cluster
- Configuration from Terraform Module for creating EKS cluster: https://github.com/daniellehopedev/terraform-learn/tree/feature/eks/terraform-aws-infra

### Python Script:
- eks-status-checks.py: https://github.com/daniellehopedev/python-automation/blob/main/eks-status-ckecks.py

---
---

### Demo Project:
Data Backup & Restore

### Technologies used:
Python, Boto3, AWS

### Project Description:
- Write a Python script that automates creating backups for EC2 Volumes
- Write a Python script that cleans up old EC2 Volume snapshots
- Write a Python script that restores EC2 Volumes
---
### Volumes:
- AWS Storage Components => stores EC2 Instance data
- when creating an EC2 instance, a volume is created and attached to that instance
- when deleting an EC2 instance, the volume will also be deleted
- Volume Snapshot => copy of a volume

### Prep:
- Create 2 EC2 instances in aws and add tags to them (one dev and one prod)

### Python Script - Creating backups:
 - volume-backups.py: https://github.com/daniellehopedev/python-automation/blob/main/volume-backups.py

 ### Python Script - Snapshot Cleanup:
 - cleanup-snapshots.py (leaves 2 latest snapshots): https://github.com/daniellehopedev/python-automation/blob/main/cleanup-snapshots.py

 ### Python Script - Restore from backup:
 - restore-volume.py: https://github.com/daniellehopedev/python-automation/blob/main/restore-volume.py

---
---

### Demo Project:
Website Monitoring and Recovery

### Technologies used:
Python, Linode, Docker, Linux

### Project Description:
- Create a server on a cloud platform
- Install Docker and run a Docker container on the remote server
- Write a Python script that monitors the website by accessing it and validating the HTTP response
- Write a Python script that sends an email notification when the website is down
- Write a Python script that automatically restarts the application & server when the application is down
---
### Prep:
1. Create a Server on Linode Cloud Platform
2. Install Docker on the server
3. Run nginx container

### Write Automation Program:
1. Write Python program that checks application endpoint and checks the status (HTTP request)
2. Send email, when website is down

### Automate fixing the problem:
1. Re-start Docker Container
2. Re-start Server

### Python Script:
- modules needed to install for the script
    - https://pypi.org/project/paramiko/
    - https://pypi.org/project/linode-api4/
- monitor-website.py: https://github.com/daniellehopedev/python-automation/blob/main/monitor-website.py

### Useful Links:
- Python Library used to send requests: https://pypi.org/project/requests/
- HTTP Response Status Codes: https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
- SMTP built-in module used to send emails: https://docs.python.org/3/library/smtplib.html
- Less Secure App Configuration (to allow for less secure sign-in from the application): https://myaccount.google.com/lesssecureapps
- Google App Passwords Configuration (when using Two-Step Verification): https://myaccount.google.com/apppasswords
- Built-in module OS (os dependant functionality ex. grabbing environment variables): https://docs.python.org/3/library/os.html
- External module for SSH Connection: https://pypi.org/project/paramiko/
- Linode API: https://pypi.org/project/linode-api4/
- Built-in module "time": https://docs.python.org/3/library/time.html