terraform {
  required_version = ">= 1.11.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config" # Connects directly to local k3s/Minikube cluster
  config_context = "default"
}
