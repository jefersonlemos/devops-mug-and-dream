resource "null_resource" "jenkins" {
  provisioner "local-exec" {
    command = <<EOT
      eval $(minikube docker-env)
      docker build -t jenkins-agent-with-docker:latest -f data/Dockerfile.jenkinsagent .
      eval $(minikube docker-env -u)

      kubectl -n shared create configmap jenkins-casc-config --from-file=jenkins.yaml=data/jenkins-as-a-code.yaml --dry-run=client -o yaml | kubectl apply -f -
      helm repo add jenkins https://charts.jenkins.io
      helm repo update
      helm upgrade --install jenkins jenkins/jenkins \
        --namespace shared \
        -f ${path.module}/data/jenkins-config.yaml
    EOT
  }

  depends_on = [kubernetes_namespace.shared]
}