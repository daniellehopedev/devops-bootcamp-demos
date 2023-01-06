# Module 8 - Build Automation & CI/CD with Jenkins

### Demo Project:
Install Jenkins on DigitalOcean

### Technologies Used:
Jenkins, Docker, DigitalOcean, Linux

### Project Objectives:
- Create an Ubuntu server on DigitalOcean
- Set up and run Jenkins as Docker container
- Initialize Jenkins
---
### Create an Ubuntu Server
1. create an ubuntu droplet
    - use atleast 1 GB of RAM for jenkins, I will be using this setup 4GB/80GB/4TB (good for long term use and similar to a production setup)
2. create a new firewall for the droplet
    - need the following ports: 22 (ssh), 8080 (jenkins)

### Set Up and Run Jenkins as a Container
1. after logging into the droplet, install docker
    - `apt update` then `apt install docker.io`
2. run the container
    - `docker run -p 8080:8080 -p 50000:50000 -d -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts`
        - port 50000 is for communication between jenkins master and worker nodes
        - jenkins/jenkins is the official jenkins image from dockerhub

### Initialize Jenkins
1. access jenkins from the browser
    - login with the provided admin credentials
    - you will be given the path to where the password is located, the path is a location inside of the container
    - can also find the same location on the droplet server by inspecting the volume: `docker volume inspect jenkins_home`
2. after login, install the suggested plugins
3. create first admin user
---
---
### Demo Project:
Create a CI Pipeline with Jenkinsfile (Freestyle, Pipeline, Multibranch Pipeline)

### Technologies Used:
Jenkins, Docker, Linux, Git, Java, Maven

### Project Objectives:
CI Pipeline for a Java Maven application to build and push to the repository
- Install Build Tools (Maven, Node) in Jenkins
- Make Docker available on Jenkins server
- Create Jenkins credentials for a git repository
- Create different Jenkins job types (Freestyle, Pipeline, Multibranch Pipeline) for the Java Maven project with Jenkinsfile to:
    - Connect to the application's git repository
    - Build Jar
    - Build Docker Image
    - Push to private DockerHub repository
---
### Install Build Tools
FYI: Jenkins Plugins - https://plugins.jenkins.io/

1. configure maven plugin
    - in Jenkins go to Manage Jenkins > Gloabal Tool Configuration
    - scroll down to maven and select Add Maven
    - enter a name, select version, and hit Save
2. install npm and nodejs in the jenkins container 
    - npm is not a plugin in jenkins, so we'll need to install it in the container
    - enter the docker container as a root user
        - `docker exec -u 0 -it <container id> bash`
    - check the linux distro with `cat /etc/issue`, used for a script you need to setup nodejs
    - install curl (if it's not already)
        - `apt update` > `apt install curl`
    - download setup script
        - `curl -sL <nodesource url> -o nodesource_setup.sh`
        - get NodeSource url from : https://github.com/nodesource/distributions
    - run the setup script
        - `bash nodesource_setup.sh`
    - install nodejs
        - `apt install nodejs`

### Make Docker Available on the Jenkins Server
1. shutdown the current running jenkins container
2. start a new container with additional volumes attached
    - need to mount the docker runtime directory from the droplet to the container as a volume
    - `docker run -p 8080:8080 -p 50000:50000 -d -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker jenkins/jenkins:lts`
3. can execute `docker` for a quick test, if you see the list of docker commands, you are good to go
4. to actually run any docker commands, you will have to change the permissions on docker.sock
    - execute `ls -l /var/run/docker.sock` to see the permissions
    - log out of the jenkins container and log back in as a root user
    - execute `chmod 666 /var/run/docker.sock`
        - will add read/write permissions for everyone

### Create Jenkins Credentials for a Git Repository

### Create Different Jenkins Job Types
#### Freestyle
#### Pipeline
#### Multibranch Pipeline