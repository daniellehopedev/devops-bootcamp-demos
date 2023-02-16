# Module 10: Container Orchestration with Kubernetes

### Demo Project:
Setup Prometheus Monitoring in Kubernetes cluster

### Technologies used:
Kubernetes, Helm, Prometheus

### Project Objectives:
- Deploy Prometheus in local Kubernetes cluster using a Helm chart
---
### Prometheus Overview
1. Prometheus Architecture
    - Prometheus Server: processes and stores metrics data
        - Retrieval: pulls metrics data (Data Retrieval Worker)
        - Storage: stores metrics data (Time Series Database)
        - HTTP Server: accepts queries (Accepts PromQL queries)
    - Alertmanager: sends alerts
    - Visualize the scraped data in the UI (ex: Grafana)
2. How to deploy all the different parts?
    1. create all configuration yaml files manually and execute them in the right order
    2. using an operator
        - can be used to manage all prometheus components
            1. find a prometheus operator
            2. deploy it in a k8s cluster
    3. use a Helm chart to deploy an operator (most efficient way)
        - helm will do the initial setup
        - operator will manage the setup

### Setup with Helm Chart
1. install the helm chart for prometheus
    - follow install instructions: https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
2. the components of prometheus
    - 2 statefulsets
        - prometheus server
        - alertmanager
    - 3 deployments
        - prometheus operator
            - created prometheus and alertmanager statefulset
        - grafana
        - kube state metrics
            - own helm chart
            - dependency of this helm chart
            - scrapes k8s components metrics
    - 3 replica sets
        - created by deployment
    - 1 daemon set
        - node exporter
        - component that runs on every worker node
        - connects to the server
        - translates worker node metrics to prometheus metrics so it can be scraped
    - pods created from deployments and statefulsets
    - services, each component has its own service
    - config maps for all the different components
        - managed by the operator
        - has info on how to connect to default metrics
    - secrets for grafana, prometheus, the operator
        - certifcates, username, password, etc
    - CRDs are created
        - extension of kubernetes api
        - custom resource definitions
3. useful command to view configurations
    - `kubectl describe statefulset <prometheus-statefulset> > <filename>.yaml`
    - will read the output of the describe to a file
4. to access grafana
    - use port-forward
    - `kubectl port-forward deployment/prometheus-grafana 3000`
    - can find the port by check kubectl logs for the grafana pod
    - `kubectl logs <grafana-pod> -c grafana`
    - access with localhost:3000
    - can use port-forward to also connect to the prometheus ui at port 9090