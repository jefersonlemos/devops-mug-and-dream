resource "null_resource" "minikube" {
  provisioner "local-exec" {
    when = create
    command = "${path.module}/data/minikube_create.sh"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "${path.module}/data/minikube_destroy.sh"
  }

  depends_on = [null_resource.setup]
}

resource "kubernetes_namespace" "shared" {
  provider = kubernetes.after_minikube
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
  provider = kubernetes.after_minikube
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
  provider = kubernetes.after_minikube
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