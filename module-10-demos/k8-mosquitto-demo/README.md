# Module 10: Container Orchestration with Kubernetes

### Demo Project:
Deploy Mosquitto message broker with ConfigMap and Secret Volume Types

### Technologies used:
Kubernetes, Docker, Mosquitto

### Project Objectives:
- Define configuration and passwords for Mosquitto message broker with ConfigMap and Secret Volume types
---
### ConfigMap and Secret Volume types
1. with configmap and secret, you can create individual key-value pairs to be used as env variables
    - they are individual values and not files that the application inside of the container can read
2. in this case we will create files that can be mounted to the pod and then to the container as volume types
    - the application in the container will be able to access it
3. mosquitto deployment without volumes: https://github.com/daniellehopedev/kubernetes-demos/blob/main/kubernetes-mosquitto-volumes/mosquitto-without-volumes.yaml
4. to enter the container: `kubectl exec -it <pod-name> -- /bin/sh`
    - navigate to the 'mosquitto' directory, there you will see config, data, and log directories
    - these are default directories
    - inside of the config directory, there will be a mosquitto.conf file (default properties and configurations)
5. to delete deployment: `kubectl delete -f <yaml-file-name>`
6. create configmap file to override the default configurations in the mosquitto.conf file
    - the configmap and secret must be created and exist before the pod starts in the kubernetes cluster
    - configmap file: https://github.com/daniellehopedev/kubernetes-demos/blob/main/kubernetes-mosquitto-volumes/mosquitto-config-file.yaml
7. create secret file: https://github.com/daniellehopedev/kubernetes-demos/blob/main/kubernetes-mosquitto-volumes/mosquitto-secret-file.yaml
8. create a deployment file with volumes: https://github.com/daniellehopedev/kubernetes-demos/blob/main/kubernetes-mosquitto-volumes/mosquitto-deployment.yaml
    - add volumes with 'volumes' property at the spec > containers level (at the same indentation level of containers)
        - this will mount the volumes to the pod
    - mount volumes into container
        - under containers, add 'volumeMounts' attribute and list the volumes