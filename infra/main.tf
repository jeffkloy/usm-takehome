module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  name      = var.project
  namespace = var.organization
  stage     = var.environment
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.2.0"

  context = module.label.context

  assign_generated_ipv6_cidr_block = false
  ipv4_primary_cidr_block          = "10.0.0.0/16"
}

module "dynamic_subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.2"

  context = module.label.context

  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
  ipv4_cidr_block    = [module.vpc.vpc_cidr_block]
  igw_id             = [module.vpc.igw_id]
  vpc_id             = module.vpc.vpc_id
}

module "eks" {
  source = "./modules/eks"

  context = module.label.context

  desired_size       = 2
  instance_type      = "m8g.medium"
  kubernetes_version = "1.32"
  max_size           = 4
  min_size           = 2
  subnet_ids         = module.dynamic_subnets.public_subnet_ids
}

resource "helm_release" "argo" {
  name       = "argo"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "8.2.4"

  create_namespace = true
  namespace        = "argo"

  values = [
    yamlencode({
      redis = {
        image = {
          repository = "redis"
          tag        = "7.2.8-alpine"
          pullPolicy = "IfNotPresent"
        }
      }
    })
  ]
}
