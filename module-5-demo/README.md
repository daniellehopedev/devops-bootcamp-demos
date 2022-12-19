# Module 5 - Cloud & Infrastructure as Service Basics

### Demo Project:
The goal of this project is to configure a server on DigitalOcean and deploy a Java application to the server.

### Technologies Used:
DigitalOcean, Linux, Java, Gradle

### Project Objectives:
- Setup and configure a server using DigitalOcean
- Create and configure a new Linux user on the server (best practice is to not use root user)
- Deploy and run a Java Gradle application
---
### Setup and configure droplet on DigitalOcean
1. Create a new droplet
2. Select Ubuntu LTS version
3. Select Basic plan
4. Select Regular and minimum storage for CPU option
5. Choose region closest to your location
6. Add or select your existing SSH key for Authentication
7. Designate how many droplets you want to deploy and edit the name if needed.
8. After creating the droplet, go to the Networking tab to configure a Firewall for accessing the droplet through ssh.
9. Set up Inbound Rule for opening port 22 for SSH
10. Assign Firewall to the droplet
11. Connection cmd: ssh root@\<droplet public ip>
12. Install Java (can just type java to see install options):
    - apt update
    - apt install \<java version option>

### Create and configure a new Linux user
1. adduser cmd: adduser \<user name>
2. follow prompts
3. add new user to "sudo" group to give sudo permissions to execute commands like a root user.
    - add user to group cmd: usermod -aG sudo \<user name>
    - switch user cmd: su - \<user name>
4. to log in as the new user directly
    - copy your public key
    - log back into the droplet as root and switch user
    - create .ssh folder and create file authorized_keys (sudo vim authorized_keys)
    - paste your public key

### Deploy and run a Java Gradle application
Example App: https://github.com/daniellehopedev/devops-bootcamp-demos/tree/main/module-5-demo/java-react-example
1. Build the jar file locally
    - cmd: ./gradlew build
2. Copy jar file (located in build/libs) to the droplet
    - cmd: scp build/libs/\<jar file> \<user on server>@\<server ip>:/\<home directory>
    - example: scp build/libs/java-react-example.jar root@ip-address:/root
3. Run the jar file
    - cmd: java -jar java-react-example.jar
    - add '&' to run in detached mode
4. Check to make sure the needed ports are open to access the application's ui