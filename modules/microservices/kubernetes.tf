# provider "kubernetes" {
#   host                   = aws_eks_cluster.eks-webapp.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.eks-webapp.certificate_authority.0.data)
#   exec {
#     api_version = "client.authentication.k8s.io/v1"
#     command     = "aws"
#     args = [
#       "eks",
#       "get-token",
#       "--cluster-name",
#       aws_eks_cluster.eks-webapp.name
#     ]
#   }
# }

/*resource "kubernetes_namespace" "game-namespace" {
  metadata {
    annotations = {
      name = "stone"
    }

    labels = {
      app = "stone"
    }

    name = "game-2048"
  }
}

resource "kubernetes_deployment" "game-deployment" {
  metadata {
    name = "app-2048"
    labels = {
      App = "app-2048"
    }
    namespace = kubernetes_namespace.game-namespace.metadata[0].name
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "app-2048"
      }
    }
    template {
      metadata {
        labels = {
          App = "app-2048"
        }
      }
      spec {
        container {
          image = "public.ecr.aws/l6m2t8p7/docker-2048:latest"
          name  = "app-2048"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "game-service" {
  metadata {
    name = "service-2048"
    namespace = kubernetes_namespace.game-namespace.metadata[0].name
  }
  spec {
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
    type = "NodePort"
    selector = {
        App = "app-2048"
    }
  }
}

resource "kubernetes_service_account" "game-service-account" {
  metadata {
    labels = {
        "app.kubernetes.io/component" = "controller"
        "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
        "eks.amazonaws.com/role-arn" = "arn:aws:iam::765074619067:role/eks-stone-role-loadbalancer"
    }    
  }
  depends_on = [aws_eks_cluster.eks-webapp]
}

resource "kubernetes_ingress" "game-ingress" {
  depends_on = [helm_release.loadbalancer_controller]
  wait_for_load_balancer = true
  metadata {
    name = "ingress-2048"
    annotations = {
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }
  spec {
    
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.game-service.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "game-ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "ingress-2048"
     annotations = {
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
    namespace = kubernetes_namespace.game-namespace.metadata[0].name
  }
  spec {
    ingress_class_name = "alb"
    
    rule {
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.game-service.metadata.0.name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_manifest" "namespace" {
  #manifest = yamldecode(file("${var.kubernetes_manifest_path}\\namespace.yaml"))
  manifest =  yamldecode(file("D:\\Tech\\aws_devops_terraform\\modules\\microservices\\kubernetes\\namespace.yaml"))
  depends_on = [aws_eks_cluster.eks-webapp]
}

resource "kubernetes_manifest" "deployment" {
  manifest =  yamldecode(file("D:\\Tech\\aws_devops_terraform\\modules\\microservices\\kubernetes\\deployment.yaml"))
  depends_on = [kubernetes_manifest.namespace]
}

resource "kubernetes_manifest" "service" {
  manifest =  yamldecode(file("D:\\Tech\\aws_devops_terraform\\modules\\microservices\\kubernetes\\service.yaml"))
  depends_on = [kubernetes_manifest.deployment]
}*/
