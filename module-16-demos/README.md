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
Configure Alerting for our application

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
1. alert-rules.yaml: https://github.com/daniellehopedev/devops-bootcamp-demos/blob/main/module-16-demos/prometheus-monitoring/alert-rules.yaml

### Configure Alertmanager With Email Receiver
- alertmanager official doc: https://prometheus.io/docs/alerting/latest/alertmanager/
- configuration: https://prometheus.io/docs/alerting/latest/configuration/#receiver
- AlertmanagerConfig: https://docs.openshift.com/container-platform/4.13/rest_api/monitoring_apis/alertmanager-monitoring-coreos-com-v1.html

1. alert-manager-configuration.yaml: https://github.com/daniellehopedev/devops-bootcamp-demos/blob/main/module-16-demos/prometheus-monitoring/alert-manager-configuration.yaml
2. email-secret.yaml: https://github.com/daniellehopedev/devops-bootcamp-demos/blob/main/module-16-demos/prometheus-monitoring/email-secret.yaml

---
---

### Demo Project:
Configure Monitoring for a Third-Party Application

### Technologies used:
Prometheus, Kubernetes, Redis, Helm, Grafana

### Project Description:
Monitor Redis by using Prometheus Exporter
- Deploy Redis service in our cluster (deployed from microservices online shop app)
- Deploy Redis exporter using Helm Chart
- Configure Alert Rules (when Redis is down or has too many connections)
- Import Grafana Dashboard for Redis to visualize monitoring data in Grafana
---
### How do we monitor third-party apps with Prometheus?
- Exporters
    - gets metrics data from the service
    - translates these service specific metrics to Prometheus understandable metrics
    - exposes these translated metrics under /metrics endpoint
    - Prometheus scrapes this endpoint
- We need to tell Prometheus about this new Exporter
    - ServiceMonitor (custom K8s resource) needs to be deployed
- Exporters Docs: https://prometheus.io/docs/instrumenting/exporters/
- Useful Links:
    - https://samber.github.io/awesome-prometheus-alerts/
    - https://grafana.com/grafana/dashboards/
    - https://grafana.com/grafana/dashboards/763-redis-dashboard-for-prometheus-redis-exporter-1-x/

### Deploy Redis Exporter
1. Redis Exporter Helm Chart: https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-redis-exporter
2. redis-values.yaml: https://github.com/daniellehopedev/devops-bootcamp-demos/blob/main/module-16-demos/prometheus-monitoring/redis-values.yaml
    - provide this values configuration when installing the chart

### Create Alert Rules
1. redis-rules.yaml: https://github.com/daniellehopedev/devops-bootcamp-demos/blob/main/module-16-demos/prometheus-monitoring/redis-rules.yaml

### Import Grafana Dashboard
1. from the redis dashboard page, grab the ID
    - https://grafana.com/grafana/dashboards/763-redis-dashboard-for-prometheus-redis-exporter-1-x/
2. in the Grafana Dashboard UI, under the Create icon, select Import
3. enter the ID and click Load
    - can change the Name
4. it will then automatically connect the exporter

---
---

### Demo Project:
Configure Monitoring for Own Application

### Technologies used:
Prometheus, Kubernetes, Node.js, Grafana, Docker, Docker Hub

### Project Description:
- Configure our NodeJS application to collect & expose Metrics with Prometheus Client Library
- Deploy the NodeJS application, which has a metrics endpoint configured, into Kubernetes cluster
- Configure Prometheus to scrape this exposed metrics and visualize it in Grafana Dashboard
---
### Monitoring Our Own Application
- Client Libraries
    - choose a prometheus client library that matches the language in which your application is written
    - abstract interface to expose your metrics
    - libraries implement the prometheus metric types (Counter, Gauge, Histogram, Summary)
- Useful Links:
    - Official Client Libraries: https://prometheus.io/docs/instrumenting/clientlibs/
    - NodeJs App Repo: https://github.com/daniellehopedev/nodejs-app-monitoring
    - NodeJs Prometheus Client: https://www.npmjs.com/package/prom-client
    - Rate function: https://prometheus.io/docs/prometheus/latest/querying/functions/#rate

### Steps to Monitor Own Application
1. Expose metrics for our Nodejs application using Nodejs client library
2. Deploy Nodejs app in the cluster
3. Configure Prometheus to scrape new target (ServiceMonitor)
4. Visualize scraped metrics in Grafana Dashboard

### Expose Metrics
1. will be exposing two metrics, Number of Requests and Duration of Requests
2. need this dependency "prom-client"
3. in server.js, to start import prom-client: `const client = require('prom-client');`
    - server.js: https://github.com/daniellehopedev/nodejs-app-monitoring/blob/main/app/server.js
4. checkout the metrics, access the app in the browser with '/metrics' endpoint

### Build Docker Image and Push to Repo (DockerHub)
1. Dockerfile: https://github.com/daniellehopedev/nodejs-app-monitoring/blob/main/Dockerfile

### Deploy App to K8s Cluster
1. k8s-config.yaml: https://github.com/daniellehopedev/nodejs-app-monitoring/blob/main/k8s-config.yaml
2. create a docker login secret using kubectl command, so kubernetes can fetch the image
    - `kubectl create secret docker-registry my-registry-key --docker-server=https://index.docker.io/v1/ --docker-username=<docker-hub-username> --docker-password=<docker-hub-password>`

### Configure Monitoring
1. k8s-config.yaml (ServiceMonitor section at bottom): https://github.com/daniellehopedev/nodejs-app-monitoring/blob/main/k8s-config.yaml

### Create Grafana Dashboard
1. Create > New dashboard
    - start with Empty Panel
2. Total Number of HTTP requests (http_request_operations_total)
    - to see total requests per second measured in two minute interval: rate(http_request_operations_total[2m])
    - paste this query in the dashboard (Metrics browser)
    - Save
3. Create another panel for http_request_duration_seconds_sum
    - duration per second for each request rate(http_request_duration_seconds_sum[2m])
    - copy the query into Metrics browser field
    - Save