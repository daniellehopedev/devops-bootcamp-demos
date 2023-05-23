# Module 16: Monitoring with Prometheus

### Demo Project:
Install Prometheus Stack in Kubernetes

### Technologies used:
Prometheus, Kubernetes, Helm, AWS EKS, eksctl, Grafana, Linux

### Project Description:
- Setup EKS cluster using eksctl
- Deploy Prometheus, Alert Manager and Grafana in the cluster as part of the Prometheus Operator using Helm chart
---
### Create EKS Cluster
1. eksctl command:
    - `eksctl create cluster` 
    - creates cluster with default configuration
        - default region
        - default AWS credentials
        - 2 worker nodes
2. check nodes
    - `kubectl get node`

### Deploy Microservices Application
1. Online Shop Microservices Application: 
    - https://github.com/daniellehopedev/microservices-demo
2. microservices kubernetes deployment config: 
    - https://github.com/daniellehopedev/kubernetes-demos/blob/main/module-16-demos/prometheus-monitoring/config-microservices.yaml
     - `kubectl apply -f config-microservices.yaml`
3. check pods
    - `kubectl get pod`

### Prometheus Stack Using Helm
1. Prometheus Helm Chart:
    - https://github.com/prometheus-community/helm-charts
2. add repository:
    - `helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`
    - pull latest from the chart repositories : `helm repo update`
3. install Prometheus into it's own namespace
    - `kubectl create namespace monitoring`
4. install Prometheus chart in the new namespace
    - `helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring`
5. print out everything deployed in the monitoring namespace
    - `kubectl get all -n monitoring`

### Prometheus Stack Components
1. 2 StatefulSets
    - prometheus server
    - alertmanager
2. 3 Deployments
    - prometheus operator (created prometheus server and alertmanager statefulset)
    - grafana
    - kube state metrics
        - it's own Helm chart
        - dependency of the prometheus helm chart
        - scrapes K8s components
3. 3 ReplicaSets
    - created by deployment
4. 1 DaemonSet
    - node exporter daemonset
        - runs on every worker node
        - connects to server
        - translates worker node metrics to prometheus metrics
5. Pods - from deployments and statefulsets
6. Services - each component has it's own
7. check the configmap
    - `kubectl get configmap -n monitoring`
    - configuration for all the different parts
    - managed by operator
    - hot to connect to default metrics
8. check the secrets
    - `kubectl get secrets -n monitoring`
    - grafana
    - prometheus
    - operator
    - alert manager
    - certificates
    - username & passwords, etc.
9. check CRDs
    - `kubectl get crd -n monitoring`
    - Custom Resource Definitions
    - extension of kubernetes api

---
---

### Demo Project:
Configure Alerting for out application

### Technologies used:
Prometheus, Kubernetes, Linux

### Project Description:
Configure our Monitoring Stack to notify us whenever CPU usage > 50% or Pod cannot start
    - Configure Alert Rules in Prometheus Server
    - Configure Alertmanager with Email Receiver
---
### Alert Rules
- alerting overview: https://prometheus.io/docs/alerting/latest/overview/
- prometheus rule docs: https://docs.openshift.com/container-platform/4.7/rest_api/monitoring_apis/prometheusrule-monitoring-coreos-com-v1.html
1. alert-rules.yaml: https://github.com/daniellehopedev/kubernetes-demos/blob/main/module-16-demos/prometheus-monitoring/alert-rules.yaml
