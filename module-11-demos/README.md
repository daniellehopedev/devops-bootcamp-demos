# Module 11: Kubernetes on AWS - EKS

### Demo Project:
Create AWS EKS cluster with a Node Group

### Technologies Used:
Kubernetes, AWS EKS

### Project Description:
- Configure necessary IAM Roles
- Create VPC with Cloudformation Template for Worker Nodes
- Create EKS cluster (Control Plane Nodes)
- Create Node Group for Worker Nodes and attach to EKS cluster
- Configure Auto-Scaling of worker nodes
- Deploy a sample application to EKS cluster
---
### Steps to create an EKS cluster
1. create EKS IAM Role
2. create VPC for Worker Nodes
3. create EKS cluster (Master Nodes)
4. connect kubectl with EKS cluster
5. create EC2 IAM Role for Node Group
6. create Node Group and attach to EKS cluster
7. configure auto-scaling
8. deploy our application to our EKS cluster

### Configure IAM Roles
1. create IAM Role in our AWS account
    - role will be assigned to EKS cluster managed by AWS
    - will allow AWS to create and manage components on our behalf
    - in IAM console, go to Roles, select 'Create role'
        - select 'AWS Service'
        - select 'EKS'
        - select 'EKS Cluster'
        - click 'Next' until the review page and enter a name
        - 'Create role'

### Create VPC for Worker Nodes
* Why create another VPC?
    - EKS cluster needs specific networking configuration
    - K8s specific and AWS specific networking rules
    - Default VPC is not optimized for it
* Worker Nodes need specific Firewall configurations
    - For Master <--> Worker Node communication
    - Best practice: configure Public Subnet (Cloud Native LoadBalancer - Elastic Load Balancer) and Private Subnet (LoadBalancer Service)
* With the IAM Role, Kubernetes has permission to change VPC configurations

1. instead of creating the VPC yourself, use a template from CloudFormation
    - go to CloudFormation in the console
    - 'Create stack'
    - select 'Template is ready'
    - select 'Amazon S3 URL'
    - copy and paste the URL for the template from: https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html
    - 'Next' then enter a name
    - leave everything else default

### Create EKS cluster
1. 'Add cluster'
    - enter a name
    - leave 'Kubernetes version' default
    - select the created IAM role for the cluster in 'Cluster service role'
    - 'Next'
    - for 'VPC', select the created VPC
    - for 'Security groups', select the SGs tied to the created VPC
    - select 'Public and private' for 'Cluster endpoint access'

### Connect kubectl
1. Create kubeconfig file
    - `aws eks update-kubeconfig --name eks-cluster-test`
2. useful commands
    - kubectl get nodes
    - kubectl get ns
    - kubectl cluster-info

### Create Node Group for Worker Nodes
* Worker Nodes run Worker Processes
* Kubelet is the main process - scheduling, managing Pods and communicate with other AWS Services
* Kubelet on Worker Node (EC2 instance) needs permission

1. create EC2 IAM Role
    - IAM > Roles > Create role
    - select 'AWS Service'
    - select 'EC2'
    - add permissions AmazonEKSWorkerNodePolicy, AmazonEC2ContainerRegistryReadOnly, AmazonEKS_CNI_Policy
    - 'Create role'
2. add node group to eks cluster
    - go to the EKS cluster, then to 'Compute' tab
    - under 'Node Groups', select 'Add node group'
    - enter a name and add the created node group role
    - on the next page, select EC2 instance type
        - select 'Amazon Linux' AMI
        - t3.small instance type
    - on the next page, enable SSH access to nodes
        - select a KeyPair
        - 'Allow SSH Access from All'
    - 'Create'
3. execute `kubectl get nodes` to see the running EC2 instances

### Configure Auto-Scaling
1. in the 'Details' section of the 'Node Group Configuration' page
    - will see 'Autoscaling group name'
2. select the autoscaling group
    - Autoscaling group logically groups EC2 instances together and has a configuration with minimum number of instances to scale down to and maximum number of instances to scale up to
    - AWS does not automatically autoscale resources 
    - have to configure K8s Autoscaler, this will work together with the autoscaling group
3. create autoscaling group (just use the default one that is created)
4. create a role for EC2 instances
    - create a custom policy
    ```
    // node-group-autoscale-policy
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "autoscaling:DescribeAutoScalingGroups",
                    "autoscaling:DescribeAutoScalingInstances",
                    "autoscaling:DescribeLaunchConfigurations",
                    "autoscaling:DescribeTags",
                    "autoscaling:SetDesiredCapacity",
                    "autoscaling:TerminateInstanceInAutoScalingGroup",
                    "ec2:DescribeLaunchTemplateVersions"
                ],
                "Resource": "*",
                "Effect": "Allow"
            }
        ]
    }
    ```
    - attach the policy to existing node group IAM Role
5. apply autoscaler discovery yaml file
    - `kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml`
    - check the cluster: `kubectl get deployment -n kube-system cluster-autoscaler`
6. update the deployment configuration
    - `kubectl edit deployment -n kube-system cluster-autoscaler`
    - in 'annotations', add: cluster-autoscaler.kubernetes.io/safe-to-evict: "false"
    - replace "YOUR CLUSTER NAME" with the actual eks cluster name (eks-cluster-test)
    - under command add: --balance-similar-node-groups and --skip-nodes-with-system-pods=false
    - update image version to the kubernetes version used by the cluster
        - use https://github.com/kubernetes/autoscaler/tags to find the version that matches with the kubernetes version on the cluster
7. can also just download the cluster-autoscaler-autodiscover.yaml and edit it with the above changes and re-apply
8. check on the pod: `kubectl get pods -n kube-system`

### Deploy Sample Application
1. sample nginx deployment config: https://github.com/daniellehopedev/devops-bootcamp-demos/blob/main/module-11-demos/nginx-config.yaml
    - internal service with AWS loadbalancer attached to it
2. apply the nginx config: `kubectl apply -f nginx.yaml`
3. see the cluster and external ips of the service
    - `kubectl get svc`
4. a loadbalancer will get created in AWS
    - the dns will match the external ip seen for the service
    - use that dns to access the ui from the browser
---
---
### Demo Project:
Create EKS cluster with Fargate profile

### Technologies Used:
Kubernetes, AWS EKS, AWS Fargate

### Project Description:
- Create Fargate IAM Role
- Create Fargate Profile
- Deploy an example application to EKS cluster using Fargate profile
---
### Fargate
- serverless way of deploying containers and creating pods in our clusters
    - no EC2 instances created in our AWS account
    - will be on an AWS managed account
- will provision a VM for each pod
- no support for stateful application or daemonsets yet
- can have Fargate in addiion to Node Group attached to our EKS cluster

### Create Fargate IAM Role
1. from the IAM console, create the role
    - the service will be EKS
2. select EKS - Fargate pod
    - for permissions you will see a pre-selected policy, AmazonEKSFargatePodExecutionRolePolicy

### Create the Fargate Profile
- Fargate Profile Overview
    - pod selection rule
    - specifies which pods should use fargate when they are launched
- Use Cases for having both Node Group and Fargate
    - can have a DEV and TEST environment inside the same cluster (ex: Node Group for TEST and Fargate for DEV)
        - pods with a specific selector is launched through Fargate
        - pods with e.g. namespace 'dev' launched through Fargate
    - may used both because of the limitations of Fargate
        - use Node Group for Stateful apps and use Fargate for Stateless apps

1. back at the eks cluster page, in the 'Compute' tab, select 'Add Fargate Profile'
2. add details
    - enter a name
    - select the created eks fargate role
    - for Subnets, remove the public subnets from the list (fargate will create the pods only on the private subnets)
    - configure pod selection
        - in nginx-config.yaml, add `namespace: dev` to the deployment metadata
        - enter that namespace in the Namespace field for 'Pod selectors'
    - configure match labels
        - in nginx-config.yaml, add `profile: fargate` to spec.selector.matchLabels and spec.template.metadata.labels for the deployment
        - add a match label with the above key and value
3. review and create

### Deploy Pod through Fargate
1. create a namespace called 'dev'
    - `kubectl create ns dev`
2. apply the nginx-config.yaml 
3. check components
    - `kubectl get pods -n dev`
        - will see one pod running
    - `kubectl get nodes`
        - will see ec2 instance and fargate profile

### Clean Up Cluster Resources
1. delete Node Groups and Fargate Profiles
2. delete the cluster
3. delete the created eks roles
4. delete the cloudformation stack 
---
---
### Demo Project:
Create EKS cluster with eksctl

### Technologies Used:
Kubernetes, AWS EKS, Eksctl, Linux

### Project Description:
- Create EKS cluster using eksctl tool that reduces the manual effort of creating an EKS cluster
---
### Create EKS cluster