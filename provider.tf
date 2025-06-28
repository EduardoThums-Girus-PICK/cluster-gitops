terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }

    spot = {
      source = "rackerlabs/spot"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

provider "spot" {
  token = var.rackspace_spot_token
}

provider "kubernetes" {
  host     = data.spot_kubeconfig.example.kubeconfigs[0].host
  token    = data.spot_kubeconfig.example.kubeconfigs[0].token
  insecure = data.spot_kubeconfig.example.kubeconfigs[0].insecure
}

provider "helm" {
  kubernetes = {
    host     = data.spot_kubeconfig.example.kubeconfigs[0].host
    token    = data.spot_kubeconfig.example.kubeconfigs[0].token
    insecure = data.spot_kubeconfig.example.kubeconfigs[0].insecure
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}
