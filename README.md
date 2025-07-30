# Hello, World!

This repository demonstrates a complete GitOps workflow for deploying hello-world on AWS EKS using Terraform, Helm, and Argo CD.

## 🚀 Overview

This project sets up:
- AWS EKS cluster with managed node groups
- Argo CD for GitOps-based continuous deployment
- Sample "Hello, World!" Go application packaged as a Helm chart
- Automated deployment pipeline with self-healing capabilities

## 📁 Directory Structure

### `/terraform` - Infrastructure as Code

Contains Terraform configuration for provisioning AWS infrastructure:

- **main.tf**: Root module orchestrating the infrastructure deployment
- **providers.tf**: AWS and Helm provider configuration
- **variables.tf**: Input variables for customizing the deployment
- **data.tf**: Data sources for fetching AWS resource information
- **helm.tf**: Deploys Argo CD via Helm with pre-configured application
- **modules/**:
  - **eks/**: EKS cluster module
    - **main.tf**: EKS cluster and node group configuration
    - **variables.tf**: Module input variables
    - **outputs.tf**: Exported values (cluster endpoint, ID, OIDC issuer)
    - **data.tf**: Module-specific data sources

### `/argo` - GitOps Configuration

Contains Argo CD application manifests:

- **hello-world.yaml**: Argo CD Application resource that defines:
  - Source repository: `https://github.com/jeffkloy/usm-takehome`
  - Target namespace: `default`
  - Sync policies: Automated with prune and self-heal enabled
  - Helm chart location: `/apps/hello-world`

### `/apps` - Application Code

Contains application source code and Kubernetes manifests:

- **hello-world/**: Sample Go web application
  - **src/main.go**: Go HTTP server serving "Hello, World!" on port 8080
  - **Dockerfile**: Multi-stage build for minimal container image
  - **Chart.yaml**: Helm chart metadata (version, description)
  - **values.yaml**: Default configuration values for the Helm chart
  - **templates/**:
    - **deployment.yaml**: Kubernetes Deployment (3 replicas by default)
    - **service.yaml**: ClusterIP Service exposing port 80

## 🏗️ Infrastructure Components

### AWS Resources
- **EKS Cluster**: Managed Kubernetes control plane
- **Node Groups**: Auto-scaling worker nodes
- **VPC & Networking**: Secure network configuration
- **IAM Roles**: Service accounts and permissions

### Kubernetes Components
- **Argo CD**: GitOps controller deployed in `argo` namespace
- **Hello World App**: Sample application in `default` namespace

## 🚦 Getting Started

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform >= 1.0
- kubectl
- Helm 3.x

### Deployment Steps

1. **Deploy Infrastructure**
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

2. **Configure kubectl**
   ```bash
   aws eks update-kubeconfig --name <cluster-name> --region <region>
   ```

3. **Access Argo CD UI**
   ```bash
   kubectl port-forward svc/argo-argo-cd-server -n argo 8080:443
   ```
   Access at: https://localhost:8080

4. **Monitor Application**
   ```bash
   kubectl get applications -n default
   kubectl get pods -n default
   ```

## 🔄 GitOps Workflow

1. Application manifests are stored in `/argo`
2. Argo CD monitors this repository for changes
3. Any updates to the application code or Helm charts trigger automatic deployment
4. Self-healing ensures the cluster state matches the Git repository

## 🛠️ Configuration

### Terraform Variables
Key variables in `terraform/variables.tf`:
- AWS region
- Cluster name
- Node group configuration

### Helm Values
Customize the application via `apps/hello-world/values.yaml`:
- Replica count
- Image repository and tag
- Service type and ports
- Resource limits

## 📊 Monitoring

- EKS cluster metrics available in AWS CloudWatch
- Argo CD provides deployment status and history
- Application logs accessible via `kubectl logs`

## 🔒 Security Considerations

- EKS cluster uses private subnets for worker nodes
- IAM roles follow principle of least privilege
- Network policies can be added for additional isolation
- Container images should be scanned for vulnerabilities
