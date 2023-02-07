# Module 10: Container Orchestration with Kubernetes

### Demo Project:
Deploy MongoDB and Mongo Express into local K8s cluster

### Project Objectives:
- Setup local K8s cluster with Minikube
- Deploy MongoDb and MongoExpress with configuration and credentials extracted into ConfigMap and Secret
---
### Setup local K8s cluster with Minikube
1. setup minkube
    - minikube is an open source tool
    - it is a one node cluster where master processes and worker processes operate on one node
    - docker is pre-installed
    - installing
        - follow official minikube documentation: https://minikube.sigs.k8s.io/docs/start/
    - starting/running minikube: https://minikube.sigs.k8s.io/docs/drivers/
    - if using local environment the docker driver is recommended
        - there will be 2 layers of docker
            1. Minikube running as a Docker container on your local machine
            2. Docker inside Minikube to run application containers
2. start minikube: `minikube start --driver docker`
    - check status: `minikube status`
    - display all nodes in a cluster: `kubectl get node`

### Deploy MongoDB and MongoExpress
1. Overview of setup:
    - create MongoDb service (pod)
        - will be an internal service, no external requests are allowed
        - communication is only allowed from components inside the same cluster
    - create MongoExpress deployment
        - will need the MongoDB url (connection)
        - will need the username and password of MongoDB (authentication)
    - ConfigMap for the DB url
    - Secret for the credentials
    - create an external service so that MongoExpress is accessible from the browser
        - URL: IP Address of Node and Port of external service
2. mongodb deployment yaml: https://github.com/daniellehopedev/kubernetes-mongo/blob/main/kubernetes-mongo/mongodb-deployment.yaml
3. create secret yaml for mongodb: https://github.com/daniellehopedev/kubernetes-mongo/blob/main/kubernetes-mongo/mongodb-secret.yaml
    - the values in the key-value pairs are not plain text, must be encoded base64
    - to encode username/password: `echo -n 'some_string' | base64`
4. deployment
    - `kubectl apply -f mongodb-deployment.yaml`
    - to view components/pod: `kubectl get all` or `kubectl get pod`
5. create service configuration for mongodb: https://github.com/daniellehopedev/kubernetes-mongo/blob/main/kubernetes-mongo/mongodb-deployment.yaml
    - can create a separate yaml file for the service or include in the same yaml as the deployment
    - to indicate document separation in yaml use 3 dashes '---'
    - apply the configuration changes with `kubectl apply -f mongodb-deployment.yaml`
        - the deployment is unchanged and the new service will be created
    - to see the IP of a pod: `kubectl get pod -o wide`
        - can compare to the IP seen in the output of `kubectl describe service mongodb-service`
6. create mongoexpress deployment, service, and configmap yaml files
    - deployment and service: https://github.com/daniellehopedev/kubernetes-mongo/blob/main/kubernetes-mongo/mongo-express-deployment.yaml
    - configmap: https://github.com/daniellehopedev/kubernetes-mongo/blob/main/kubernetes-mongo/mongo-express-configmap.yaml
7. create external service or add it to the deployment yaml configuration file
8. assign the service an external IP with minikube
    - `minikube service <service-name>`
    - will open up a browser to access mongoexpress