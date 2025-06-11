# dview-stack Helm Chart

dview-stack is a Helm chart for deploying a data processing and analytics platform on Kubernetes, integrated with ArgoCD for GitOps-based continuous delivery. It manages a suite of services and tools, ensuring scalability and consistency through declarative configurations.

## Directory Structure
```
umbrella-chart/
├── Chart.yaml          # Metadata and dependencies for the parent chart
├── values.yaml         # Default configurations for the parent chart and subcharts
├── charts/             # Subcharts for individual services and tools
│   ├── service-a/      # Subchart for service-a
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   │       ├── deployment.yaml
│   │       ├── service.yaml
│   │       └── hpa.yaml
│   ├── service-b/      # Subchart for service-b
│   │   └── ...
│   └── tool-x/         # Subchart for tool-x
│       └── ...
├── templates/          # Parent chart Kubernetes resources
│   ├── deployments/    # Shared deployments (e.g., initialization jobs)
│   ├── infrastructure/ # Shared infrastructure (e.g., ConfigMaps, Secrets)
│   ├── networking/     # Networking resources
│   │   ├── ingress/   # Ingress configurations
│   │   ├── services/  # Shared service definitions
│   │   └── virtualservices/  # Istio VirtualService definitions
│   └── rbac/          # RBAC configurations
└── README.md           # Documentation for chart usage
```

## Purpose
This chart enables a GitOps workflow with ArgoCD to:

1. Deploy and synchronize all tools and services.
2. Centralize service configuration and secrets.
3. Automate scaling with HPA, dependency sequencing and routing with Istio.

## Features

1. **Sub-Charts:** Per-service resources (Deployment, Service, VirtualService, PVC, HPA).
2. **ArgoCD Integration:** GitOps-driven deployment and sync.
3. **Configuration:** Single values.yaml for global and service-specific settings.
4. **Secrets:** dview-secrets for environment variables.
5. **Istio:** VirtualServices for routing.
6. **Autoscaling:** HPA for resource optimization.
7. **Sidecars:** Additional containers per service.


## Services and Tools

The chart deploys the following components:
1. **Services:** Apollo, Artemis, Cerebrum, Cortex, Cosmos, Jobweaver, Mirage, Trinity
2. **Tools:** Airflow, Hive, Kafka, MySQL, Neo4j, Rangeradmin, Redis, Trino
3. **Other:** Shared secret (dview-secrets)


## Prerequisites

1. Kubernetes (v1.20+)
2. Helm (3.x)
3. ArgoCD (for GitOps)
4. Istio (for VirtualServices)
5. kubectl (for cluster access)
6. Git (for repository cloning)


## Installation
Full Chart Installation
```
Clone the Repository:
git clone <repository-url>
cd dview-stack
```

## Update values.yaml (optional):

1. Modify global.deploy to enable/disable components.
2. Adjust global.service for resource limits, replicas, or service-specific settings.
3. Configure global.virtualService for Istio routing.


## Install the Chart:
```
helm install dview-stack . --namespace onboarding --create-namespace --values values.yaml
```

## Verify Deployment:
```
kubectl get pods -n onboarding
```

## Sync with ArgoCD (if using GitOps):
```
argocd app create dview-stack --repo <repository-url> --path . --dest-namespace onboarding --dest-server https://kubernetes.default.svc
argocd app sync dview-stack
```


## Installing a Single Subchart
To deploy only one subchart (e.g., apollo):

Option 1: Use Parent Chart with Selective Deployment:

Create a custom values.yaml (e.g., apollo-only.yaml):
```
global:
  deploy:
    secret: true
    mysql: true  # Required dependency
    apollo: true
    # Set all other services/tools to false
    airflow: false
    hive: false
    redis: false
    kafka: false
    trino: false
    rangeradmin: false
    neo4j: false
    cerebrum: false
    artemis: false
    mirage: false
    cosmos: false
    trinity: false
    cortex: false
    jobweaver: false
```

**Install with:**
```
helm install dview-stack . --namespace onboarding --create-namespace --values apollo-only.yaml
```

Option 2: Install Subchart Directly:

Navigate to the subchart directory: 
```
cd charts/apollo
```
Install the subchart, overriding parent settings if needed: 
```
helm install apollo . --namespace onboarding --create-namespace --set global.service.apollo.app.image=dview/apollo
```


## Uninstallation
```
helm uninstall dview-stack -n onboarding
kubectl delete namespace onboarding
```
