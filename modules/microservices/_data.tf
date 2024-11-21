data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com","ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "stone_eks_assume_role_policy" {
  statement {
  actions = ["sts:AssumeRoleWithWebIdentity"]
  effect = "Allow"
  principals {
  identifiers = [aws_iam_openid_connect_provider.stone.arn]
  type = "Federated"
  }
  condition {
  test = "StringEquals"
  variable = "${replace(aws_iam_openid_connect_provider.stone.url, "https://", "")}:aud"
  values = ["sts.amazonaws.com"]
  }
  condition {
  test = "StringEquals"
  variable = "${replace(aws_iam_openid_connect_provider.stone.url, "https://", "")}:sub"
  values = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
  }
  
 }
}

data "tls_certificate" "stone" {
 url = aws_eks_cluster.eks-webapp.identity[0].oidc[0].issuer
}

data "aws_eks_cluster" "stone" {
 name = aws_eks_cluster.eks-webapp.name
}