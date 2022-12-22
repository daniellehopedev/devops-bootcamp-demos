# Module 7 - Containers with Docker

### Demo Project 1:
Use docker for local development

### Technologies Used:
Docker, Node.js, MongoDB, MongoExpress

### Project Objectives:
- Create Dockerfile for NodeJS application and build Docker image
- Run NodeJS application in Docker container and connect to MongoDB database container locally
- Run MongoExpress container as a UI of the MongoDB database
---
### Create Dockerfile for NodeJS app
1. create a file, 'Dockerfile' in your project's root directory
    - sample file: https://github.com/daniellehopedev/devops-bootcamp-demos/tree/main/module-7-demos/developing-with-docker/Dockerfile
2. build the Docker image based on the Dockerfile
 - cmd: `docker build -t [name of image]:[version tag] [directory location]`
    - example: `docker build -t my-node-app:1.0 .` (the dot (.) is the current directory, should also be where the Dockerfile is located)
3. view list of docker images to verify the image is created
    - cmd: `docker images`
4. run the app in a container
    - cmd: `docker run [image name]:[tag]`
5. to access and see inside of the container
    - cmd: `docker exec -it [container id] /bin/bash` (can use /bin/sh if /bin/bash doesn't work)

### Create a Network for connection between MongoDB and MongoExpress containers
*NOT MANDATORY TO CREATE A NETWORK, CAN USE DEFAULT DOCKER NETWORK*
1. to see a list of current networks
    - `docker network ls`
2. create a network for the mongo connections
    - `docker network create [network name]`

### Run MongoDB database in a container
1. pull mongo image from dockerhub
    - `docker pull mongo`
2. run mongodb container
    - `docker run -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password --name mongodb --net mongo-network mongo`
    - env variables needed
        - MONGO_INITDB_ROOT_USERNAME
        - MONGO_INITDB_ROOT_PASSWORD
    - 'mongo-network' would be the created network

### Run MongoExpress in a container
1. pull mongo-express image from dockerhub
    - docker pull mongo-express
2. run mongo-express container
    - `docker run -d -p 8081:8081 -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin -e ME_CONFIG_MONGODB_ADMINPASSWORD=password --net mongo-network --name mongo-express -e ME_CONFIG_MONGODB_SERVER=mongodb mongo-express`
    - env variables needed
        - ME_CONFIG_MONGODB_ADMINUSERNAME
        - ME_CONFIG_MONGODB_ADMINPASSWORD
        - ME_CONFIG_MONGODB_SERVER (name of mongodb container)