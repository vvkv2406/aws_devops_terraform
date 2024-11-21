resource "aws_eks_cluster" "eks-webapp" {
  name     = local.name
  role_arn = aws_iam_role.eks-stone-role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-stone-policy
  ]
}

/*resource "aws_eks_node_group" "eks-webapp-node-group" {
  cluster_name    = aws_eks_cluster.eks-webapp.name
  node_group_name = format("%s-%s",local.name,"ng")
  node_role_arn   = aws_iam_role.eks-stone-role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-stone-policy
  ]
}*/