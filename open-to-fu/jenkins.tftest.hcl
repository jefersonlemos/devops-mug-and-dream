run "jenkins_null_resource" {
  assert {
    condition     = tofu.resource.null_resource.jenkins.id != null
    error_message = "Jenkins null_resource was not created."
  }
  assert {
    condition     = length(tofu.resource.null_resource.jenkins.provisioner) >= 2
    error_message = "Jenkins null_resource does not have both provisioners."
  }
}
