# Module 7 - Containers with Docker

This will include 3 demo projects:
1. Dockerize Nodejs application and push to private Docker registry
2. Deploy Docker application on a server with Docker
Compose
3. Persist Data with Docker Volumes

### Demo Project 1:
Dockerize Nodejs application and push to private Docker registry

### Technologies used:
Docker, Node.js, Amazon ECR

### Project Objectives:
- Write Dockerfile to build a Docker image for a Nodejs application
- Create private Docker registry on AWS (Amazon ECR)
- Push Docker image to this private repository
---
### Create Dockerfile to Build a Docker Image
1. created Dockerfile
    - https://github.com/daniellehopedev/devops-bootcamp-demos/blob/main/module-7-demos/docker-private-registry-demo/developing-with-docker/Dockerfile
### Create private registry on AWS
1. login to AWS console, go to Services, select/search ECR (Elastic Container Registry)
2. create repository
    - name the repository similar to the nodejs app name/image
    - for AWS ECR, you create one repository per image (unique image)
    - you can have many versions (tags) of the same image in one repository

### Push Docker image to the private repo
NOTE: the commands for pushing will be shown in the 'View push commands' popup on the AWS console
1. select the repository and select 'View push commands' to see the commands for pushing to the repository
    - docker login
        - the aws login command executes docker login under the hood
        - do not have to do docker login everytime you need to push to the repo
2. make sure your image is built with the Dockerfile
3. tag your image with 'docker tag' command (make sure to have the exact version of the tag)
    - with this you are basically making a copy and renaming the image you built
4. run the docker push command
---
---
### Demo Project 2:
Deploy Docker application with Docker Compose

### Technologies used:
Docker, Amazon ECR, Node.js, MongoDB, MongoExpress

### Project Objectives:
- Create a docker-compose file configured for deploying the Node.js app, MongoDB,  and MongoExpress
- Login to private Docker registry to fetch the app image
- Start the application container with MongoDB and MongoExpress services using docker compose
---
### Create the Docker Compose File to Remote Server
1. docker-compose sample:
    - https://github.com/daniellehopedev/devops-bootcamp-demos/blob/main/module-7-demos/docker-private-registry-demo/developing-with-docker/mongo.yaml

### Login to the Private Docker Registry to Fetch the Image
1. pull the image from ECR
    - execute docker login command (can use the same aws docker login command from the push commands)
    - execute docker pull command (make sure you copy the ECR repository name and add the version tag)

### Start the App container with MongoDB and MongoExpress services
1. run the docker-compose command to deploy the Node.js app, MongoDB, and MongoExpress and start the containers
    - `docker-compose -f <yaml file> up`
2. access node app at localhost:3000 and access mongo-express at localhost:8080
---
---
### Demo Project 3:
Persist data with Docker Volumes

### Technologies used:
Docker, Node.js, MongoDB

### Project Objectives:
- Persist data of a MongoDB container by attaching a Docker volume to it
---
### Update Docker Compose File and Configure the Volume
1. add volumes at the services level
2. reference the added volumes within the needed services
3. docker-compose file with volumes
    - https://github.com/daniellehopedev/devops-bootcamp-demos/blob/main/module-7-demos/docker-private-registry-demo/developing-with-docker/mongo.yaml
4. access the app and make some data changes
    - access node app at localhost:3000
    - or access mongo-express ui at localhost:8080
5. restart the containers with docker-compose
6. the data should be persisted
