resource "null_resource" "jenkins" {
  provisioner "local-exec" {
    command = <<EOT
      docker build -t jenkins:latest -f ../docker/jenkins/Dockerfile ../docker/jenkins
      minikube image load jenkins:latest
      helm upgrade --install jenkins jenkins/jenkins --namespace shared
    EOT
  }

  depends_on = [kubernetes_namespace.shared]
}