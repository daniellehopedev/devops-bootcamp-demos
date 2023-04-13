# Module 11: Kubernetes on AWS - EKS

### Demo Project:
CD - Deploy to EKS cluster from Jenkins Pipeline

### Technologies used:
Kubernetes, Jenkins, AWS EKS, Docker, Linux

### Project Description:
- Install kubectl and aws-iam-authenticator on a Jenkins server
- Create kubeconfig file to connect to EKS cluster and add it on Jenkins server
- Add AWS credentials on Jenkins for AWS account authentication
- Extend and adjust Jenkinsfile of the previous CI/CD pipeline to configure connection to EKS cluster
---
### Install kubectl on Jenkins Server
1. ssh into your digital ocean droplet: `ssh root@<server-ip>`
2. start up jenkins container
3. ssh into the jenkins container as root user: `docker exec -u 0 -it <container-id> bash`
4. install kubectl
    - instructions: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
    - execute permissions if needed and move the executable to /usr/local/bin folder
        - `chmod +x ./kubectl`
        - `mv ./kubectl /usr/local/bin/kubectl`

### Install AWS IAM Authenticator
1. download the aws-iam-authenticator 
    - instructions: https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
    - edit execute permissions if needed and move the executable to /usr/local/bin folder
        - `chmod +x ./aws-iam-authenticator`
        - `mv ./aws-iam-authenticator /usr/local/bin`

### Create kubeconfig file for Jenkins
1. use the contents found here for AWS IAM Authenticator for Kubernetes
    - create kubeconfig file manually: https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html
    - sample file: https://github.com/daniellehopedev/kubernetes-demos/blob/main/kubernetes-eks-jenkins/config
    - things to update:
        1. cluster-name: k8s cluster you want to connect to
        2. server endpoint url: the eks api server endpoint (public endpoint for talking to the cluster)
        3. certificate-authority-data
            - gets generated in the eks cluster when it gets created
            - can find this in your local kubeconfig file that was generated from eksctl 
2. copy the file to the jenkins user home directory in the jenkins container
    - log in to the jenkins container as jenkins user: `docker exec -it <container-id> bash`
    - go to jenkins home directory: `cd ~   # should be in /var/jenkins_home`
    - create .kube directory inside the jenkins_home folder
    - use docker copy to copy the config file from the droplet server to the jenkins container
        - `docker cp config <container-id>:/var/jenkins_home/.kube/`

### Create AWS Credentials
- best practice would be to:
    - Create AWS IAM User for Jenkins with limited permissions
1. inside the multi-branch pipeline you want to run, go to 'Credentials'
    - 'Add Credentials'
    - for 'Kind', select 'Secret text'
    - ID => jenkins_aws_access_key_id
    - Secret => will be the actual aws access key id
    - Add another credential for the secret access key
    - ID => jenkins_aws_secret_access_key
    - Secret => will be the actual aws secret access key

### Configure Jenkinsfile to deploy to EKS
1. in the java-maven-app project, update the Jenkinsfile
    - Jenkinsfile: https://github.com/daniellehopedev/java-maven-app/blob/feature/k8s-eks-deploy/Jenkinsfile

---
---

### Demo Project:
Complete CI/CD Pipeline with EKS and private DockerHub registry

### Technologies used:
Kubernetes, Jenkins, AWS EKS, Docker Hub, Java, Maven, Linux, Docker, Git

### Project Description:
- Write K8s manifest files for Deployment and Service configuration
- Integrate deploy step in the CI/CD pipeline to deploy newly built application image from DockerHub private registry to the EKS cluster
- So the complete CI/CD project we build has the following configuration
    a. CI step: Increment version
    b. CI step: Build artifact for Java Maven application
    c. CI step: Build and push Docker image to DockerHub
    d. CD step: Deploy new application version to EKS cluster
    e. CD step: Commit the version update
---
---
### Demo Project:
Complete CI/CD Pipeline with EKS and AWS ECR

### Technologies used:
Kubernetes, Jenkins, AWS EKS, AWS ECR, Java, Maven, Linux, Docker, Git

### Project Description:
- Create private AWS ECR Docker repository
- Adjust Jenkinsfile to build and push Docker image to AWS ECR
- Integrate deploying to K8s cluster in the CI/CD pipeline from AWS ECR private registry
- So the complete CI/CD project we build has the following configuration:
    a. CI step: Increment version
    b. CI step: Build artifact for Java Maven application
    c. CI step: Build and push Docker image to AWS ECR
    d. CD step: Deploy new application version to EKS cluster
    e. CD step: Commit the version update