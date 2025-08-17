run "minikube_apply" {
  command = apply

  assert {
    condition     = kubernetes_namespace.infra.metadata[0].name == "infra"
    error_message = "Namespace 'infra' doesn't exist."
  }

  assert {
    condition     = kubernetes_namespace.dev.metadata[0].labels.mylabel == "dev"
    error_message = "Namespace 'dev' doesn't exist."
  }

  assert {
    condition     = kubernetes_namespace.prod.metadata[0].annotations.description == "release apps"
    error_message = "Namespace 'prod' doesn't exist."
  }
}