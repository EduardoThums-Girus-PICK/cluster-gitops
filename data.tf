data "spot_kubeconfig" "example" {
  cloudspace_name = var.cloudspace_name
  depends_on      = [spot_cloudspace.example]
}

# data "kubernetes_service_v1" "ingress" {
#   metadata {
#     name = "ingress-nginx-controller"
#     namespace = "ingress-nginx"
#   }
# }