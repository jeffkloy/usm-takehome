data "aws_eks_cluster" "eks_cluster" {
  name = module.eks.eks_cluster_id
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = module.eks.eks_cluster_id
}
