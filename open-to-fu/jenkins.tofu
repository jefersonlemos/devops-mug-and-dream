resource "null_resource" "jenkins" {
  provisioner "local-exec" {
    command = <<EOT
      docker build -t custom-jenkins:custom -f ../docker/jenkins/Dockerfile ../docker/jenkins
      minikube image load custom-jenkins:custom
      helm upgrade --install jenkins ../helm/jenkins --namespace shared
      
      helm repo add bitnami https://charts.bitnami.com/bitnami
      helm repo update
      helm install registry bitnami/schema-registry --namespace shared --set auth.enabled=false --set serviceAccount.name=registry --set service.ports.http=5000
    EOT
  }

  depends_on = [kubernetes_namespace.shared]
}