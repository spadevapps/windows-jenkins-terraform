terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}
provider "kubernetes" {
//  config_path = "/home/ansiblem/.kube/config"
    config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "flaskapp" {
  metadata {
    annotations = {
      name = "flaskapp"
    }

    labels = {
      App = "ScalableNginxExample"
    }

    name = "flaskapp"
  }
}


resource "kubernetes_deployment" "flaskapp" {
  metadata {
    namespace = kubernetes_namespace.flaskapp.metadata.0.name
    name      = "flaskapp"
    labels = {
      App = "flaskapp"
    }
  }
  spec {
    replicas = 4
    selector {
      match_labels = {
        App = "flaskapp"
      }
    }
    template {
      metadata {
        labels = {
          App = "flaskapp"
        }
      }
      spec {
        container {
          image = "tomkugelman/capstone-flask:latest"
          //image = "spadevapps/casestudy2"
          name  = "example"
          port {
            container_port = 80
          }

        }
      }
    }
  }
  timeouts {
    create = "3m"
    update = "3m"
    delete = "3m"
  }
}
resource "kubernetes_service" "flaskapp" {
  metadata {
    namespace = kubernetes_namespace.flaskapp.metadata.0.name
    name      = "flaskapp"
  }
  spec {
    selector = {
      App = kubernetes_deployment.flaskapp.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
