run "providers_configured" {
  assert {
    condition     = tofu.provider.kubernetes.config_context == "minikube"
    error_message = "Kubernetes provider is not using 'minikube' context."
  }
  assert {
    condition     = tofu.provider.helm.kubernetes.config_context == "minikube"
    error_message = "Helm provider is not using 'minikube' context."
  }
}
