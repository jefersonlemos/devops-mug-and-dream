resource "null_resource" "destroy_minikube" {
  count = var.delete_minukube ? 1 : 0

  provisioner "local-exec" {
    when    = create
    command = "echo 'nothing to create here'"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/data/destroy.sh"
  }
}