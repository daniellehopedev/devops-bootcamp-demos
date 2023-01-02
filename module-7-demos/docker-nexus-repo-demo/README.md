# Module 7 - Containers with Docker

### Demo Project:
Create Docker repository on Nexus and push to it

### Technologies Used:
Docker, Nexus, DigitalOcean, Linux

### Project Objectives:
- Create Docker hosted repository on Nexus
- Create Docker repository role on Nexus
- Configure Nexus, DigitalOcean Droplet, and Docker to be able to push to Docker repository
- Build and Push Docker image to Docker repository on Nexus
---
### Create Docker Hosted Repository
1. login to Nexus server (DigitalOcean Droplet from Module 6)
2. in administration and configuration view, (gear icon) select 'Create repository'
3. choose docker (hosted)
    - enter a name and select a blob store, leave other options default

### Create Docker Repo Role on Nexus
1. in roles, create a new role for the docker hosted repo
    - select 'Nexus role'
    - enter an id and a name
    - under 'Privileges', select 'nx-repository-view-docker-docker-hosted-*'
2. add new role to existing user, user that was used for the maven-snapshot repo

### Configure Nexus, DigitalOcean Droplet, and Docker
1. select the created docker-hosted repo and update the HTTP field
    - docker client can't connect to a path, uses IP:PORT
    - need a different port for docker, since in my case 8081 is used for Nexus itself
    - this will open a different for docker to be accessable at the IP from the URL to the docker-hosted repo
2. update the droplet firewall to open the new port set for the docker-hosted repo
3. configure Realms to handle the issueing of the docker token used for docker login
    - go to 'Realms' and add 'Docker Bearer Token Realm'
4. configure docker
    - docker only allows client requests to talk to HTTPS endpoints
    - need to configure docker client to allow requests to HTTP since it is insecure
    - if possible edit /ect/docker/daemon.json file
    - otherwise in Docker Desktop, go to settings, Docker Engine
        - add `"insecure-registries": [ "<nexus IP>:<port set for docker repo>" ]` to the json
5. execute docker login command with the repository ip and port
    - type in nexus user and password
    - the docker config.json will now have the token that the docker repository issued back to the client so you don't have to login every time.

### Build and Push Docker Image to Nexus Docker Repo
1. build an image
2. re-tag the image for the nexus docker-hosted repo
    - `docker tag <image name:tag> <nexus repo ip:port>/<image name:tag>`
3. push the re-tagged image to the repository