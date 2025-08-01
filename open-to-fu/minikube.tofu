resource "null_resource" "start_minikube" {
  provisioner "local-exec" {
    command = "${path.module}/data/setup.sh"
  }
}