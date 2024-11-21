variable "eks-webapp" {
    type = string
    default = "eks-webapp"
}
variable "repo-name" {
    type = string
    default =  "webapp-repo"
}

variable "user-name" {
    type = string
    default =  "webapp-user"
}

variable "vpc_id" {
    type = string
    default =  ""
}

variable "subnet_ids" {
    type = list(string)
    default =  []
}

variable "iam_policy_arn_eks" {
  description = "IAM Policy to be attached to role"
  type = list
  default = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy","arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy","arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy","arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}

variable "kubernetes_manifest_path" {
    type = string
    default = "D:\\Tech\\aws_devops_terraform\\modules\\microservices\\kubernetes"
}