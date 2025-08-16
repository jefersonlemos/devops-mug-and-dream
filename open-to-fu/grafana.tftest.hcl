run "grafana_helm_release" {
  assert {
    condition     = tofu.resource.helm_release.grafana.name == "grafana"
    error_message = "Helm release name is not 'grafana'"
  }
  assert {
    condition     = tofu.resource.helm_release.grafana.namespace == "infra"
    error_message = "Helm release namespace is not 'infra'"
  }
}
