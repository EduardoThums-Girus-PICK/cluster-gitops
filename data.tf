data "spot_kubeconfig" "example" {
  cloudspace_name = var.cloudspace_name
  depends_on      = [spot_cloudspace.example]
}
