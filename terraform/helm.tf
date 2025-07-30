resource "helm_release" "argo" {
  name             = "argo"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "8.2.4"
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
      server = {
        additionalApplications = [
          {
            name      = "apps"
            namespace = "default"
            project   = "default"
            source = {
              repoURL        = "https://github.com/jeffkloy/usm-takehome"
              targetRevision = "HEAD"
              path           = "argo"
              directory = {
                recurse = true
              }
            }
            destination = {
              server    = "https://kubernetes.default.svc"
              namespace = "default"
            }
            syncPolicy = {
              automated = {
                prune    = true
                selfHeal = true
              }
              syncOptions = [
                "CreateNamespace=true"
              ]
            }
          }
        ]
      }
    })
  ]
}
