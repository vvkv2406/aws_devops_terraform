provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks-webapp.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks-webapp.certificate_authority.0.data)
    exec {
        api_version = "client.authentication.k8s.io/v1"
        command     = "aws"
        args = [
        "eks",
        "get-token",
        "--cluster-name",
        aws_eks_cluster.eks-webapp.name
        ]
    }
  }
}

resource "helm_release" "loadbalancer_controller" {
  depends_on = [aws_iam_role_policy_attachment.eks-stone-elb-role-policy,kubernetes_service_account.game-service-account]
  name       = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  namespace = "kube-system"

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller" # Changes based on Region - This is for us-east-1 Additional Reference: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.eks-stone-role-loadbalancer.arn
  }

  set {
    name  = "vpcId"
    value = data.terraform_remote_state.eks.outputs.vpc_id
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "clusterName"
    value = aws_eks_cluster.eks-webapp.name
  }

}
