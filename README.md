# Hello, world! (USM take-home assessment)

This repository demos a complete GitOps workflow for deploying `hello-world` (sample app) on AWS EKS using Terraform, Helm, and Argo CD.

## 🚀 Overview and Explanation

This project sets up:
- AWS EKS cluster with a managed node group
- Sample "Hello, World!" Go application packaged as a Helm chart and built/pushed via GitHub Actions into GHCR
- Argo CD for GitOps-based continuous deployment; pipeline with self-healing capabilities
- No actual deployment is done in this repo due to having no attached infrastructure
- Tested using LocalStack
- Most of README.md was written using AI (Claude), apart from overview & explainers

Why this approach was taken:  
This take-home project has GitOps principles with Argo as the CD engine, allowing us to have a pull-based deployment model that maintains a git repo as the single "source of truth" whilst allowing there to be self-healing capabilities. The choice of AWS EKS eliminates Kubernetes control plane management overhead, while Terraform modules from CloudPosse provide tested & repeatable infrastructure patterns. Helm packaging enables templated & versioned app deployments across environments, and GitHub Actions builds & pushes to GHCR, to provide a secure integrated CI pipeline that triggers only on changes to specific files & directories.

## 📁 Directory Structure

### `/apps` - Applications and Manifests

- **hello-world.yaml**: Argo CD Application manifest for GitOps deployment
- **hello-world/**: Sample Go web application packaged as Helm chart
  - **src/main.go**: Go HTTP server serving "Hello, World!" on port 8080
  - **Dockerfile**: Multi-stage build for minimal container image
  - **Chart.yaml**: Helm chart metadata (version, description)
  - **values.yaml**: Default configuration values for the Helm chart
  - **templates/**:
    - **deployment.yaml**: Kubernetes Deployment (3 replicas by default)
    - **service.yaml**: ClusterIP Service exposing port 80

### `/charts` - Helm Charts

- **argo-applications/**: Helm chart for deploying Argo CD applications
  - **Chart.yaml**: Chart metadata
  - **values.yaml**: Configuration values
  - **templates/application.yaml**: Template for Argo CD Application resources

### `/terraform` - Infrastructure as Code

- **main.tf**: Main Terraform configuration
- **providers.tf**: Provider configurations (AWS, Kubernetes, Helm)
- **variables.tf**: Input variables
- **data.tf**: Data sources
- **helm.tf**: Helm releases (Argo CD deployment)
- **modules/eks/**: EKS cluster module
  - **main.tf**: EKS cluster and node group resources
  - **variables.tf**: Module input variables
  - **outputs.tf**: Module outputs
  - **data.tf**: Module data sources

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
- `kubectl`
- `Helm` 3.x
- [OPTIONAL] LocalStack, and:
   - `awscli-local`
   - `terraform-local`

### Deployment Steps

1. **Deploy Infrastructure**
   ```bash
   cd terraform
   terraform/tflocal init
   terraform/tflocal plan
   terraform/tflocal apply
   ```

2. **Configure kubectl**
   ```bash
   aws/awslocal eks update-kubeconfig --name [CLUSTER NAME] --region [REGION]
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

1. Application manifests are stored in `/apps/*.yaml`
2. Argo CD monitors this directory for changes
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

## 🔒 Security Considerations

- EKS cluster uses private subnets for worker nodes
- IAM roles follow principle of least privilege
- Network policies can be added for additional isolation
- Container images should be scanned for vulnerabilities

## 🧑‍🔬 Testing Scenario for Rollback

To test Argo CD's rollback capabilities, you can intentionally introduce a failing deployment by modifying the `hello-world` application to use a non-existent Docker image tag or create an invalid configuration. For example, you can update `apps/hello-world/values.yaml` to be `image.tag: "null"`, and then commit the change. Argo CD will try to sync this change, causing its pods be to fail to pull the image, and stick to the last working version. Alternatively, you can trigger a rollback through the Argo CD by selecting the application `hello-world`, clicking "History", and choosing a previous successful revision to roll back to. The self-healing parts can be tested by manually deleting or modifying resources directly in the cluster - Argo CD will detect the drift and automatically restore the desired state from the git repository.
