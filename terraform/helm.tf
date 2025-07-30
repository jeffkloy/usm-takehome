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
            name      = "applications"
            namespace = "argo"
            project   = "default"
            source = {
              repoURL        = "https://github.com/jeffkloy/usm-takehome.git"
              targetRevision = "HEAD"
              path           = "apps"
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
