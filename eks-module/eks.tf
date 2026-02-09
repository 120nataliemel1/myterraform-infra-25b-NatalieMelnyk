# EKS Cluster is the actual Kubernetes control plane. It manages the Kubernetes API, scheduling, and overall cluster state. 
# The worker nodes (EC2 instances) will be registered to this cluster to run your applications.
resource "aws_eks_cluster" "projectx_cluster" {
  name = var.cluster_name

  # EKS supports two authentication modes: API and IAM. 
  # API mode uses the Kubernetes API server for authentication, while IAM mode uses AWS IAM for authentication.
  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster.arn # EKS Cluster requires an IAM Role with specific permissions to manage AWS resources on behalf of the cluster. This role is used by EKS to create and manage resources such as EC2 instances, load balancers, and security groups.
  version  = "1.34"                   #Eks cluster one version release prior to latest in K8s per task req.

  vpc_config {
    subnet_ids = var.subnets
    #EKS req public subnets for cluster endpoint access, even if worker nodes are in private subnets.
    security_group_ids = [aws_security_group.cluster_sg.id]

  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}