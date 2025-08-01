resource "null_resource" "destroy_minikube" {
  provisioner "local-exec" {
    when    = create
    command = "echo 'nothing to create here'"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/data/destroy.sh"
  }
}
