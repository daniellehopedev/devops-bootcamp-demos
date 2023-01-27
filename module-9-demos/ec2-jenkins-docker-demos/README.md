# Module 9: AWS Services

### Demo Project:
Deploy Web Application on EC2 Instance (manually)

### Technologies Used:
AWS, Docker, Linux

### Project Objectives:
- Create and configure an EC2 Instance on AWS
- Install Docker on remote EC2 Instance
- Deploy Docker image from private Docker repository on EC2 Instance
---
### Create and configure an EC2 Instance on AWS
1. create and configure an AWS account with EC2 permissions if needed
2. search in services for EC2
3. click 'Launch Instance'
    - enter a Name for your instance
    - select AMI (amazon machine image) => Amazon Linux
    - select instance type => t2.micro (free tier eligible)
    - create a key pair to be able to connect to the instance
        - download the private key locally
        - public key is automatically stored by AWS
        - choose default key pair type RSA
        - if on mac or linux, choose private key file format .pem; for windows choose .ppk
    - network configuration
        - auto-assign pubic IP address should be enabled, to ssh into the instance
        - configure a security group (firewall rules)
            - make sure port 22 is open (for connection through ssh)
            - in 'Source type' select 'My IP', so only your IP has access
    - Launch Instance!
4. from EC2 dashboard, click on instances to see running instance

### Install Docker on remote EC2 Instance
1. connect to EC2 instance through ssh, using the key pair
    - save the downloaded .pem file in the .ssh folder in your home directory
    - fix the permissions on the file, so that it has read permission only for your user
        - `chmod 400 .ssh/docker-server.pem`
    - copy the public ip address connect to the instance
        - `ssh -i ~/.ssh/docker-server.pem ec2-user@<instance ip>`
        - default user on ec2 instance is ec2-user and you must attach the pem file (key pair) to the command to connect
2. install docker
    - `sudo yum update` => to update the package manager tool to get the up-to-date repositories
    - `sudo yum install docker`
    - `sudo service docker start` => to start the docker daemon
3. add ec2-user to docker group, so you don't have to run docker commands with 'sudo'
    - `sudo usermod -aG docker $USER`
    - log out of the instance and log back in for changes to register

### Pull Docker Image from Dockerhub Repo and Run the Container
1. clone the react-nodejs-example app from github
2. build a docker image and push it to dockerhub repo
3. the web app uses port 3080 inside the container, so that port needs to be bound on the server port so it is accessible
4. pull the image from the dockerhub repo
    - execute `docker login`
    - execute docker pull command to pull the image from dockerhub
5. run the image as a container
    - `docker run -d -p 3000:3080 <image-name>:<tag>`
6. access the application from the browser
    - need to add port 3000 to the security group rules
    - click on 'Security Groups' from the side menu, then select the security group
    - click 'Edit inbound rules' to add port 3000
7. app should now be accessible at port 3000 in the browser: `<ec2-public-ip>:3000`
---
---
### Demo Project:
CD - Deploy Application from Jenkins Pipeline to EC2 Instance (automatically with docker)

### Technologies Used:
AWS, Jenkins, Docker, Linux, Git, Java, Maven, Docker Hub

### Project Objectives:
- Prepare AWS EC2 Instance for deployment (Install Docker)
- Create ssh key credentials for EC2 server on Jenkins
- Extend the previous CI pipeline with deploy step to ssh into the remote EC2 instance and deploy newly built image from Jenkins server
- Configure security group on EC2 Instance to allow access to our web application
---
### Configure and EC2 Instance and Install Docker
1. follow the setup in the first two sections from the previous demo above

### Create ssh key credentials for EC2 server on Jenkins
1. install SSH Agent plugin in Jenkins
2. create ssh key credentials for the .pem file
    - in the multibranch pipeline, create credentials only for this pipeline's scope
    - click 'Credentials' from the menu and click the store for the specific pipeline and create credentials
    - select 'SSH Username with private key'
        - enter an id
        - enter 'ec2-user' for username
        - copy and paste the content of the .pem file
3. use the credentials in the jenkinsfile for connecting to the ec2 remote server
    - go to 'Pipeline Syntax' in the side menu of your pipeline, you can generate a script for using SSH Agent
    - scroll to 'Steps' section and select 'sshagent: SSH Agent' and select your credentials
    - click 'Generate Pipeline Script' and it will generate a sample script for you to use in the jenkinsfile
4. update the jenkinsfile, add the sshagent syntax in the deploy step

### Extend the previous CI pipeline for java-maven-app with a deploy step
1. add a deploy stage to the CI pipeline in the jenkinsfile
    - this step will ssh into the ec2 server and deploy the docker image that was pushed to the dockerhub repository
```
stage('deploy') {
    steps {
        script {
            echo 'deploying docker image to EC2...'
            def dockerCmd = "docker run -p 8080:8080 -d ${IMAGE_NAME}"
            sshagent(['ec2-server-key']) {
                // -o StrictHostKeyChecking=no, suppresses popup when connecting to the ec2 server
                sh "ssh -o StrictHostKeyChecking=no ec2-user@<ec2-server-ip> ${dockerCmd}"
                // make sure to do 'docker login' on the ec2 server if needed
            }
        }
    }
}
```
2. add the ip of jenkins to the Source list in the security group for the ec2 server
    - this is for allowing jenkins to ssh into the ec2 server
3. ssh into the ec2 instance to check if image was deployed and to see container running

### Configure security group on EC2 Instance
1. add a rule for port 8080 to the security group, to allow access to the application from the browser