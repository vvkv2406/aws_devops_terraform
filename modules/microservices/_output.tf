
/*output "stone_ecr_repository_url" {
  value = aws_ecr_repository.stone-ecr.repository_url
}

output "endpoint" {
  value = aws_eks_cluster.eks-webapp.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks-webapp.certificate_authority[0].data
}

output "clusterinfo" {
  value = aws_eks_cluster.eks-webapp.identity[0].oidc[0].issuer
}

# Display load balancer hostname (typically present in AWS)
output "load_balancer_hostname" {
  value = kubernetes_ingress_v1.game-ingress.status.0.load_balancer.0.ingress.0.hostname
}

# Display load balancer IP (typically present in GCP, or using Nginx ingress controller)
output "load_balancer_ip" {
  value = kubernetes_ingress_v1.game-ingress.status.0.load_balancer.0.ingress.0.ip
}
*/