resource "null_resource" "jenkins" {
  provisioner "local-exec" {
    command = <<EOT
      docker build -t custom-jenkins:custom -f ../docker/jenkins/Dockerfile ../docker/jenkins
      minikube image load custom-jenkins:custom
      helm upgrade --install jenkins ../helm/jenkins --namespace shared
    EOT
  }

  depends_on = [kubernetes_namespace.shared]
}