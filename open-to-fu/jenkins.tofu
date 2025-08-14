resource "null_resource" "jenkins" {
  provisioner "local-exec" {
    when = create
    command = <<EOT
      docker build -t custom-jenkins:custom -f ../docker/jenkins/Dockerfile ../docker/jenkins
      minikube image load custom-jenkins:custom
      helm install jenkins ../helm/jenkins --namespace infra
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "helm uninstall jenkins --namespace infra"
    
  }

  depends_on = [kubernetes_namespace.infra]
}