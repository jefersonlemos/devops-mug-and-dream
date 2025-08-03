resource "null_resource" "minikube" {
  provisioner "local-exec" {
    command = "${path.module}/data/minikube.sh"
  }
  depends_on = [null_resource.setup]
}

resource "kubernetes_namespace" "shared" {
  metadata {
    annotations = {
      description = "this namespace should be used for shared applications"
    }

    labels = {
      mylabel = "shared"
    }

    name = "shared"
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

