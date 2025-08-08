output "minikube_ip" {
  value = data.external.minikube_ip.result.ip
}