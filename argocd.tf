resource "helm_release" "argocd" {
  depends_on = [null_resource.wait_for_nodes_ready]

  name             = "argo"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
  namespace        = "argocd"
  wait             = true # Will wait until all resources are in a ready state before marking the release as successful.
  values           = [file("./argocd/values.yaml")]
}

resource "kubectl_manifest" "cluster_boostrap" {
  yaml_body  = templatefile("./argocd/applicationSet.tftpl", { cloudflare_token = var.cloudflare_token, ingress_auth = var.ingress_auth })
  depends_on = [helm_release.argocd]
}
