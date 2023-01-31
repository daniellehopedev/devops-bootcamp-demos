# Module 9: AWS Services

### Demo Project:
CD - Deploy Application from Jenkins Pipeline on EC2 Instance (automatically with docker-compose)

### Technologies used:
AWS, Jenkins, Docker, Linux, Git, Java, Maven, Docker Hub

### Project Objectives:
- Install Docker Compose on AWS EC2 Instance
- Create docker-compose.yaml file that deploys our web application image
- Configure Jenkins pipeline to deploy newly built image using Docker Compose on EC2 server
- Improvement: Extract multiple Linux commands that are executed on the remote server into a separate shell script and execute the script from the Jenkinsfile
---
### Install docker compose
1. from: https://docs.docker.com/compose/install/other/ copy the command to download and install docker compose
```
sudo curl -SL https://github.com/docker/compose/releases/download/v2.15.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
```
2. make the docker-compose binary executable
```
sudo chmod +x /usr/local/bin/docker-compose
```

### Create docker-compose.yaml
1. docker-compose.yaml: https://github.com/daniellehopedev/java-maven-app/blob/feature/jenkinsfile-ec2-docker/docker-compose.yaml
    - will start 2 containers: the java maven docker image and a Postgres docker image

### Configure Jenkins pipeline
1. update the deploy step in the jenkinsfile
2. need to copy the docker-compose file from the repository to the ec2 instance
    - using secure copy
    ```
    // setting a variable for the docker-compose command to run on the ec2 instance
    // outside of sshagent block, setup docker compose command to use on the ec2 instance
    def dockerComposeCmd = "docker-compose -f docker-compose.yaml up --detach"
    // add this inside of sshagent block, before the ssh into the ec2 server
    sh "scp docker-compose.yaml ec2-user@<ec2-ip>:/home/ec2-user"
    // then update the ssh command with the dockerComposeCmd variable instead of the dockerCmd variable
    ```
3. jenkinsfile: https://github.com/daniellehopedev/java-maven-app/blob/feature/jenkinsfile-ec2-docker/Jenkinsfile

### Extract the Linux commands from the jenkinsfile into a separate shell script
1. create a shell script: https://github.com/daniellehopedev/java-maven-app/blob/feature/jenkinsfile-ec2-docker/server-cmds.sh
```
#! /usr/bin/env bash

docker-compose -f docker-compose.yaml up --detach
echo "success"
```

2. replace dockerComposeCmd variable with shellCmd variable and set the command to run the shell script
    - `def shellCmd = "bash ./server-cmds.sh"`
    - this file needs to be copied to the ec2 server along with the docker compose file
        - `sh "scp server-cmds.sh ec2-user@<ec2-ip>:/home/ec2-user"`
---
---
### Demo Project:
Complete the CI/CD Pipeline (Docker-Compose, Dynamic versioning)

### Technologies used:
AWS, Jenkins, Docker, Linux, Git, Java, Maven, Docker Hub

### Project Description:
- CI step: Increment version
- CI step: Build artifact for Java Maven application
- CI step: Build and push Docker image to Docker Hub
- CD step: Deploy new application version with Docker Compose
- CD step: Commit the version update
---
### CI step: Increment version
1. update the Jenkinsfile 
    - remove the IMAGE_NAME environment variable
    - replace it with the 'increment version' stage, same code snip used in the webhooks demo
    ```
    stage('increment version') {
        steps {
            script {
                echo 'incrementing app version...'
                // maven command that increments the version in the pom file
                sh 'mvn build-helper:parse-version versions:set \
                    -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} versions:commit'
                // read the version from the pom file and set it as the IMAGE_NAME
                def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                def version = matcher[0][1]
                // BUILD_NUMBER is a value from the Jenkins pipeline builds
                env.IMAGE_NAME = "$version-$BUILD_NUMBER"
            }
        }
    }
    ```

NOTE: For CI step: Build artifact for Java Maven application, CI step: Build and push Docker image to Docker Hub, and CD step: Deploy new application version with Docker Compose,
the code and set up will be very similar as the previous demo above.

### CD step: Commit the version update
1. update the Jenkinsfile
    - add a 'commit version update' step, same code snip used in the webhooks demo
    ```
    stage('commit version update') {
        steps {
            script {
                sshagent(['github-ssh-credentials']) {
                    // on the jenkins server, setting the remote url for the repository to commit and push to
                    sh "git remote set-url origin git@github.com:daniellehopedev/java-maven-app.git"
                    sh 'git add .'
                    // the commit and push will be as the jenkins user
                    sh 'git commit -m "ci: version bump"'
                    sh 'git push origin HEAD:feature/jenkinsfile-ec2-docker'
                }
            }
        }
    }
    ```

2. Jenkinsfile: https://github.com/daniellehopedev/java-maven-app/blob/feature/jenkinsfile-ec2-docker/Jenkinsfile