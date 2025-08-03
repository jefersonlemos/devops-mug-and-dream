resource "null_resource" "setup" {
  provisioner "local-exec" {
    when = create
    command = "${path.module}/data/setup.sh"
  }
}