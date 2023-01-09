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
    - download setup script for NodeSource
        - get installation instructions from : https://github.com/nodesource/distributions

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

NOTE: depending on the version of Ubuntu you are using for your droplet, you may encounter an issue with the docker installation. If you can't run `docker` or you see any error related to "GLIBC". Follow the steps below to help resolve your issue:

1. create a Dockerfile on the server
```
FROM jenkins/jenkins:lts
RUN curl -sSL https://get.docker.com/ | sh
USER jenkins
```
2. tag and build a new jenkins image based on the Dockerfile
`docker build -t jenkins-with-docker .`
3. run jenkins container with the new image, without the "(which docker)" volume

### Create Jenkins Credentials for a Git Repository
1. in Jenkins UI on the dashboard, click on Manage Jenkins
2. click on Manage Credentials
3. in the table, under domains, click (global)
4. click Add Credentials button
    - select 'Username with Password'
    - if setting up with username and password
        - username = github/gitlab username
        - password = github/gitlab password
    - if setting up with ssh
        - make sure your private key is added with the credentials in Jenkins
        - select 'SSH Username with private key'
        - enter your username, and copy your private key
    - enter an id and description
5. click Create button

### Create Different Jenkins Job Types

#### Freestyle
1. in Jenkins UI on the dashboard, click 'New Item'
2. enter a name and select 'Freestyle Project'
    - under Source Code Management, select Git
        - enter the repository url (github or gitlab)
        - select credentials or add credentials and specify the branch name
    - add build steps
        - select 'Invoke top-level Maven targets'
        - select Maven version
        - add Goals (Test, Package, etc.)
3. building a docker image
     - in the freestyle job dashboard, click configure
     - add on a build step, 'Execute shell'
     - enter docker commands
        ```
        docker build -t java-maven-app:1.0 .
        ```
    - save
4. pushing image to dockerhub (private docker repository)
    - add new Jenkins credentials for dockerhub
    - configure your credentials as secrets to be used in the docker login command
        - in configuration > build environment, select 'Use secret text(s) or file(s)
        - in bindings select 'Username and password (separated)'
        - enter variable names of your liking
        - choose 'Specific Credentials' and select the dockerhub credentials
        - save
    - update docker commands with docker push
        ```
        docker build -t <name of dockerhub repo>:<tag> .
        docker login -u $USERNAME -p $PASSWORD
        docker push <image name>
        ```
NOTE: if there is a warning like this in the logs: "Using --password via the CLI is insecure. Use --password-stdin...", update the docker login command to `echo $PASSWORD | docker login -u $USERNAME --password-stdin`

5. BONUS: deploying to Nexus
    - since nexus is not secure https, it is http, need to configure insecure repository in Jenkins
    - in the Jenkin server, not the container, create daemon.json file
        - `vim /etc/docker/daemon.json`
        - add this:
            ```
            { 
                "insecure-registries": ["<nexus ip: docker repo port>"]
            }
            ```
    - restart docker, `systemctl restart docker`
    - restart Jenkins container, will have to update the docker.sock permissions in the container again (every time docker stops and starts)
    - create Nexus credentials in Jenkins (the user with permissions for the docker repo)
    - select the Nexus credentials in the freestyle job configuration
    - update docker commands:
        ```
        docker build -t <nexus ip:docker repo port>/<app-name>:<tag> .
        echo $PASSWORD | docker login -u $USERNAME --password-stdin <nexus ip: docker repo port>
        docker push <image name>
        ```

#### Pipeline
#### Multibranch Pipeline