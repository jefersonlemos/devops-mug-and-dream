resource "null_resource" "minikube" {
  provisioner "local-exec" {
    when = create
    command = "${path.module}/data/minikube_create.sh"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/data/minikube_destroy.sh"
  }
}

resource "kubernetes_namespace" "infra" {
  metadata {
    annotations = {
      description = "this namespace should be used for infra applications"
    }

    labels = {
      mylabel = "infra"
    }

    name = "infra"
  }
  depends_on = [ null_resource.minikube ]
}

resource "kubernetes_namespace" "dev" {
  metadata {
    annotations = {
      description = "development ecossystem"
    }

    labels = {
      mylabel = "dev"
    }

    name = "dev"
  }
  depends_on = [ null_resource.minikube ]
}

resource "kubernetes_namespace" "prod" {
  metadata {
    annotations = {
      description = "release apps"
    }

    labels = {
      mylabel = "prod"
    }

    name = "prod"
  }
  depends_on = [ null_resource.minikube ]
}