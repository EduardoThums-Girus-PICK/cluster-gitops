variable "rackspace_spot_token" {
  description = "Rackspace Spot authentication token"
  type        = string
  sensitive   = true
}

variable "cloudspace_name" {
  description = "The name of the cloudspace in Rackspace"
  type        = string
  default     = "girus"
}

variable "spot_cloudspace_region" {
  description = "Region for the cloudspace spot"
  type        = string
  default     = "us-central-dfw-1"
}

variable "spot_cloudspace_server_count" {
  description = "The desired count of servers to be running"
  type        = number
  default     = 1
}

variable "kubeconfig_path" {
  description = "The path for the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "argocd_cloudflare_token" {
  type      = string
  sensitive = true
}

variable "argocd_ingress_auth" {
  type      = string
  sensitive = true
}

variable "argocd_cert_manager_enabled" {
  type      = bool
  sensitive = true
}

variable "argocd_ingress_nginx_enabled" {
  type      = bool
  sensitive = true
}

variable "argocd_girus_enabled" {
  type      = bool
  sensitive = true
}

variable "argocd_girus_ingress_enabled" {
  type      = bool
  sensitive = true
}

# variable "cloudflare_zone_id" {
#   type      = string
#   sensitive = true
# }

