terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29.0"
    }
  }
}

provider "kubernetes" {
  alias          = "after_minikube"
  config_path    = "~/.kube/config"
  config_context = "minikube"
}
