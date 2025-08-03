resource "null_resource" "setup" {
  provisioner "local-exec" {
    command = "${path.module}/data/setup.sh"
  }
}