resource "null_resource" "minikube" {
  provisioner "local-exec" {
    command = "${path.module}/data/minikube.sh"
  }
  depends_on = [null_resource.setup]
}