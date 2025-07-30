module "eks_cluster" {
  source  = "cloudposse/eks-cluster/aws"
  version = "4.6.0"

  context = var.context

  kubernetes_version    = var.kubernetes_version
  subnet_ids            = var.subnet_ids
  oidc_provider_enabled = true
}

module "eks_node_group" {
  source  = "cloudposse/eks-node-group/aws"
  version = "3.3.2"

  context = var.context

  instance_types     = [var.instance_type]
  kubernetes_version = [var.kubernetes_version]

  desired_size = var.desired_size
  min_size     = var.min_size
  max_size     = var.max_size

  cluster_name          = module.eks_cluster.eks_cluster_id
  create_before_destroy = true
  subnet_ids            = var.subnet_ids

  cluster_autoscaler_enabled = true
}
