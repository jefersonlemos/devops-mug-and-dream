resource "null_resource" "prometheus" {
  provisioner "local-exec" {
    when = create
    command = <<EOT
      helm upgrade --install prometheus ../helm/prometheus --namespace infra
    EOT
  }

  provisioner "local-exec" {
    when = destroy
    command = <<EOT
      helm uninstall prometheus --namespace infra
    EOT
  }

  depends_on = [kubernetes_namespace.infra]
}

resource "null_resource" "grafana" {
  provisioner "local-exec" {
    when = create
    command = <<EOT
      helm upgrade --install grafana ../helm/grafana --namespace infra
    EOT
  }

  provisioner "local-exec" {
    when = destroy
    command = <<EOT
      helm uninstall grafana --namespace infra
    EOT
  }

  depends_on = [kubernetes_namespace.infra]
}

resource "null_resource" "kube-state-metrics" {
  provisioner "local-exec" {
    when = create
    command = <<EOT
      helm upgrade --install kube-state-metrics ../helm/kube-state-metrics --namespace infra
    EOT
  }

  provisioner "local-exec" {
    when = destroy
    command = <<EOT
      helm uninstall kube-state-metrics --namespace infra
    EOT
  }

  depends_on = [kubernetes_namespace.infra]
}