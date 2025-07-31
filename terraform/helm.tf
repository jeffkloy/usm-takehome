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
    })
  ]
}


resource "helm_release" "argo_applications" {
  name      = "argo-applications"
  chart     = "../charts/argo-applications"
  namespace = "argo"

  depends_on = [helm_release.argo]
}
