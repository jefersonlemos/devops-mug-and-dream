resource "null_resource" "jenkins" {
  provisioner "local-exec" {
    command = <<EOT
      docker build -t custom-jenkins:custom -f ../docker/jenkins/Dockerfile ../docker/jenkins
      minikube image load custom-jenkins:custom
      helm install jenkins ../helm/jenkins --namespace infra
    EOT
  }

  depends_on = [kubernetes_namespace.infra]
}