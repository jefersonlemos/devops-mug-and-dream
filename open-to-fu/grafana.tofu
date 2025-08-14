resource "helm_release" "grafana" {
  name      = "grafana"
  namespace = "infra"
  chart     = "grafana/grafana"
  values    = [file("./data/grafana_values.yaml")]
  depends_on = [kubernetes_namespace.infra]
}