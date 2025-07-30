# Hello, World!

This repository contains infrastructure code, application code, and GitOps configurations for deploying a Kubernetes application on AWS EKS.

## Directory Structure

### `/infra` - Infrastructure as Code

Contains Terraform configuration for provisioning AWS infrastructure:

- **main.tf**: Root module that orchestrates the infrastructure deployment
- **providers.tf**: AWS provider configuration
- **variables.tf**: Input variables for the Terraform configuration
- **data.tf**: Data sources for fetching AWS resource information
- **modules/**:
  - **eks/**: EKS cluster module
    - Provisions managed Kubernetes cluster
    - Configures node groups for worker nodes
    - Sets up IAM roles and security groups

### `/argo` - GitOps Configuration

Contains Argo CD application manifests:

- **hello-world.yaml**: Argo CD Application resource that defines:
  - Source repository location
  - Target Kubernetes namespace
  - Sync policies for automated deployment
  - Helm chart path and configuration

### `/apps` - Application Code

Contains application source code and Kubernetes manifests:

- **hello-world/**: Sample Go web application
  - **src/main.go**: Go application that serves "Hello, World!" on port 8080
  - **Dockerfile**: Container image definition
  - **Chart.yaml**: Helm chart metadata
  - **values.yaml**: Default configuration values for the Helm chart
  - **templates/**:
    - **deployment.yaml**: Kubernetes Deployment manifest
    - **service.yaml**: Kubernetes Service manifest for exposing the application
