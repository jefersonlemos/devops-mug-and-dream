data "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = "infra"
  }

  depends_on = [ null_resource.jenkins ]
}

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

output "jenkins_service_id" {
  value = data.kubernetes_service.jenkins.id
}