# EKS Cluster is the actual Kubernetes control plane. It manages the Kubernetes API, scheduling, and overall cluster state. 
# The worker nodes (EC2 instances) will be registered to this cluster to run your applications.
resource "aws_eks_cluster" "projectx_cluster" {
  name                      = var.cluster_name
  enabled_cluster_log_types = ["api", "audit"]
  role_arn                  = aws_iam_role.cluster.arn # EKS Cluster requires an IAM Role with specific permissions to manage AWS resources on behalf of the cluster. This role is used by EKS to create and manage resources such as EC2 instances, load balancers, and security groups.
  version                   = var.k8s_version          #Eks cluster one version release prior to latest in K8s per task req.
  # EKS supports two authentication modes: API and IAM. 
  # API mode uses the Kubernetes API server for authentication, while IAM mode uses AWS IAM for authentication.
  access_config {
    authentication_mode = "API"
  }

  vpc_config {
    endpoint_public_access = true # Enable public access to the EKS cluster endpoint, allowing kubectl and other tools to connect to the cluster API from outside the VPC. This is required for cluster management and operations, even if worker nodes are in private subnets.
    subnet_ids             = var.subnets
    #EKS req public subnets for cluster endpoint access, even if worker nodes are in private subnets.
    security_group_ids = [aws_security_group.cluster_sg.id]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]

  tags = {
    "Name"                                      = var.cluster_name
    "project"                                   = var.project_name
    "environment"                               = var.environment
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

data "aws_eks_cluster" "projectx" {
  name = aws_eks_cluster.projectx_cluster.name
}

locals {
  cluster_endpoint = aws_eks_cluster.projectx_cluster.endpoint
  cluster_ca_b64   = aws_eks_cluster.projectx_cluster.certificate_authority[0].data

  # EKS cluster service CIDR (for nodeadm networking section)
  service_cidr = data.aws_eks_cluster.projectx.kubernetes_network_config[0].service_ipv4_cidr
}
