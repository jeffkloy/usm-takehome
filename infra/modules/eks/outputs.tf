output "eks_cluster_endpoint" {
  value = module.eks_cluster.eks_cluster_endpoint
}

output "eks_cluster_id" {
  value = module.eks_cluster.eks_cluster_id
}

output "eks_cluster_identity_oidc_issuer" {
  value = module.eks_cluster.eks_cluster_identity_oidc_issuer
}
