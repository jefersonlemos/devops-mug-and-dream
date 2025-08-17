run "jenkins_null_resource" {
  command = apply

  assert {
    condition     = output.jenkins_service_id != null
    error_message = "Jenkins service doesn't exist."
  }
}
