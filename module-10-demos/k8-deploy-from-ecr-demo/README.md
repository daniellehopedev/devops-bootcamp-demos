# Module 10: Container Orchestration with Kubernetes

### Demo Project:
Deploy our web application in K8s cluster from private Docker registry

### Technologies used:
Kubernetes, AWS ECR, Docker

### Project Objectives:
- Create Secret for credentials for the private Docker registry
- Configure the Docker registry secret in application Deployment component
- Deploy web application image from our private Docker registry in K8s cluster
---
### Create Secret for credentials
1. create a secret yaml that will have the credentials for connecting to aws ecr so docker will have the access to pull the image
    - need to do a docker login to create a config.json
    - in the aws console for ecr, there is a view push commands button
        - this will show the docker login command that can be used
2. useful CLI commands for docker login and configuring a config.json file for the secret
    - https://github.com/daniellehopedev/kubernetes-demos/blob/main/kubernetes-aws-ecr/docker-ecr-cli-commands.md
3. minikube cannot access the credsStore from your local machine because it is running it's own docker and it is essentially a virtual box.
    - need to ssh into minikube to generate a .docker/config.json file that will have the docker login creds for ecr in it's own credsStore
    ```
    minikube ssh
    ```
    - get the password needed for the docker login command
    ```
    aws ecr get-login-password --region <aws-region>
    ```
    - copy the password into the docker login command to login to docker and generate the config.json on minikube
    ```
    docker login -u AWS -p <copied-password> <ecr-endpoint>
    ```
4. use the config.json to create the secret component for the cluster
5. copy the config.json from minikube to your local with secure copy or minikube cp
6. then encode the contents of the file to base64 and paste the output as the value for .dockerconfigjson in the secret component
    - secret yaml: https://github.com/daniellehopedev/kubernetes-demos/blob/main/kubernetes-aws-ecr/docker-secret.yaml
    - or use the kubectl command to create the secret instead of having to encode and copy it to the yaml
        - kubectl command: `kubectl create secret generic <secret-name> --from-file=.dockerconfigjson=.docker/config.json --type=kubernetes.io/dockerconfigjson`
        - this will also be applied and the secret will be created just like when using kubectl apply on the secret yaml
    - another whay to create a secret without having to do docker login and going through multiple steps
        - this way is best when you only need to make one key for one repository
        - using the config.json file will allow you to store a secret that will access to multiple repos
    ```
    kubectl create secret docker-registry <secret-name> --docker-server=<private-repo-url> --docker-username=AWS --docker-password=pwd
    ```
7. create the deployment component: https://github.com/daniellehopedev/kubernetes-demos/blob/main/kubernetes-aws-ecr/app-deployment.yaml
