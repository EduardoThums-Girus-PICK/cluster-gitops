resource "spot_cloudspace" "example" {
  cloudspace_name    = var.cloudspace_name
  region             = var.spot_cloudspace_region
  hacontrol_plane    = false
  wait_until_ready   = true
  kubernetes_version = "1.31.1"
  cni                = "calico"
}

resource "spot_spotnodepool" "autoscaling-bid" {
  cloudspace_name      = resource.spot_cloudspace.example.cloudspace_name
  server_class         = "gp.vs1.large-dfw"
  bid_price            = 0.02
  desired_server_count = var.spot_cloudspace_server_count
}

resource "local_file" "kubeconfig" {
  depends_on = [data.spot_kubeconfig.example]
  content    = data.spot_kubeconfig.example.raw
  filename   = pathexpand(var.kubeconfig_path)
}

resource "null_resource" "wait_for_nodes_ready" {
  depends_on = [spot_cloudspace.example, local_file.kubeconfig]

  provisioner "local-exec" {
    command     = <<EOT
      echo "Waiting for ${var.spot_cloudspace_server_count} Kubernetes nodes to be Ready..."
      for i in {1..20}; do
        ready=$(kubectl get nodes --no-headers 2>/dev/null | grep -c " Ready ")
        if [ "$ready" -eq "${var.spot_cloudspace_server_count}" ]; then
          echo "All $ready nodes are Ready."
          exit 0
        fi
        echo "Currently Ready: $ready / ${var.spot_cloudspace_server_count} — retrying ($i)..."
        sleep 60
      done
      echo "Timeout waiting for ${var.spot_cloudspace_server_count} nodes to become Ready."
      exit 1
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
