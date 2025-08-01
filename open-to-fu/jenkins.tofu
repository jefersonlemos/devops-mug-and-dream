resource "null_resource" "helm_install_jenkins" {
  provisioner "local-exec" {
    command = <<EOT
      helm repo add jenkins https://charts.jenkins.io
      helm repo update
      helm upgrade --install jenkins jenkins/jenkins \
        --namespace jenkins --create-namespace \
        -f ${path.module}/data/jenkins-values.yaml
    EOT
  }

  depends_on = [null_resource.start_minikube]
}