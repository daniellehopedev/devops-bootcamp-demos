# Module 6 - Artifact Repository Manager with Nexus

### Demo Project:
Run Nexus on a Droplet (DigitalOcean) and publish an artifact to Nexus.

### Technologies Used:
Nexus (Sonatype), DigitalOcean, Linux, Java, Gradle, Maven

### Project Objectives:
- Install and configure Nexus from scratch on a cloud server
- Create new user on Nexus with relevant permissions
- Java Gradle Project: Build jar and upload to Nexus
- Java Maven Project: Build jar and upload to Nexus
---
### Install and configure Nexus
1. Create Ubuntu Server (Droplet on DigitalOcean) - min 4GB RAM & 2 CPUs
2. Open SSH port 22 (Networking -> Firewall)
3. Install Java 8 (apt update & apt install)
    - can type 'java' in the terminal to see install options
4. Download and Install Nexus
    - switch to /opt directory
    - download Nexus from url https://download.sonatype.com/nexus/3/nexus-3.44.0-01-unix.tar.gz
    - untar the tar file - 3 folders will be unpackaged
        - nexus folder has the runtime and binaries to run the application
        - sonatype-work folder has the data and config for Nexus
    - add a new user for the Nexus service (do not use root user to run Nexus)
    - switch ownership of nexus directories to the new user
        - cmd: chown -R user:group directory
    - update nexus configuration setup to run the service as the new user
        - update nexus.rc file in the nexus /bin folder, set run_as_user to the new user
        - switch to the new user
    - cmd to start Nexus
        - /opt/\<nexus folder>/bin/nexus start
    - update the firewall on the droplet to open port 8081 to access Nexus

### Create new user on Nexus
1. Sign in with default 'admin' user
    - can find password in /opt/sonatype-work/nexus3/admin.password
    - will be prompted to reset password
2. Create a new User and create a new Role
    - will need a role like 'nx-repository-view-maven2-maven-snapshots-*' for uploading and retrieving repository data
3. Assign the role to the user
4. Can now use this user's credentials to configure maven/gradle for uploading the artifact/jar to the repository.

### Java Gradle Project: Build jar and upload to Nexus
1. Configure the Gradle project
    - add 'maven-publish' plugin
2. Configure publications block and repositories block
    - sample code: https://github.com/daniellehopedev/devops-bootcamp-demos/blob/main/module-6-demo/java-app/build.gradle
3. Build the jar using ./gradlew cmd
4. Publish the jar using ./gradlew publish (publish comes from the maven-publish plugin)

### Java Maven Project: Build jar and upload to Nexus
1. Configure the Maven project
    - similar to the Gradle project, need to add plugin and configuration for connection to the nexus repository using the nexus user credentials
    - sample code:  https://github.com/daniellehopedev/devops-bootcamp-demos/blob/main/module-6-demo/java-maven-app/pom.xml
2. In .m2 folder (in home directory), create settings.xml file
    - sample code: https://github.com/daniellehopedev/devops-bootcamp-demos/blob/main/module-6-demo/sample-settings.xml
3. Build the jar: mvn package
4. Publish the jar to nexus: mvn deploy