run "minikube_namespaces" {
  assert {
    condition     = tofu.resource.kubernetes_namespace.infra.metadata["name"] == "infra"
    error_message = "Namespace 'infra' was not created."
  }
  assert {
    condition     = tofu.resource.kubernetes_namespace.infra.metadata["labels"].mylabel == "infra"
    error_message = "Namespace 'infra' does not have the correct label."
  }
  assert {
    condition     = tofu.resource.kubernetes_namespace.dev.metadata["name"] == "dev"
    error_message = "Namespace 'dev' was not created."
  }
  assert {
    condition     = tofu.resource.kubernetes_namespace.dev.metadata["labels"].mylabel == "dev"
    error_message = "Namespace 'dev' does not have the correct label."
  }
  assert {
    condition     = tofu.resource.kubernetes_namespace.prod.metadata["name"] == "prod"
    error_message = "Namespace 'prod' was not created."
  }
  assert {
    condition     = tofu.resource.kubernetes_namespace.prod.metadata["labels"].mylabel == "prod"
    error_message = "Namespace 'prod' does not have the correct label."
  }
}