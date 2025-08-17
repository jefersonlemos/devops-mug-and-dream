run "providers_configured" {
  assert {
    condition     = provider.kubernetes.config_context == "minikube"
    error_message = "Kubernetes provider is not using 'minikube' context."
  }
  assert {
    condition     = provider.helm.kubernetes.config_context == "minikube"
    error_message = "Helm provider is not using 'minikube' context."
  }
}
