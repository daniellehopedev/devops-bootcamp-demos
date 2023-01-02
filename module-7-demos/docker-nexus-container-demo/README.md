# Module 7 - Containers with Docker

### Demo Project:
Deploy Nexus as Docker container

### Technologies Used:
Docker, Nexus, DigitalOcean, Linux

### Project Objectives
- Create and Configure Droplet
- Set up and run Nexus as a Docker container
---
### Create and Configure Droplet
1. on DigitalOcean, create a new Ubuntu Droplet
2. configure a firewall to allow access to port 22
3. ssh into the droplet
4. install Docker

### Set Up and Run Nexus Container
1. on dockerhub, search for nexus3 image
    - sonatype official image sonatype/nexus3
2. configure a volume for the nexus container to persist data
    - `docker volume create --name nexus-data`
3. start nexus docker container
    - `docker run -d -p 8081:8081 --name nexus -v nexus-data:/nexus-data sonatype/nexus3`
4. to see the location of the data from the created volume in the server
    - `docker inspect nexus-data`