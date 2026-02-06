# EKS Cluster is the actual Kubernetes control plane. It manages the Kubernetes API, scheduling, and overall cluster state. 
# The worker nodes (EC2 instances) will be registered to this cluster to run your applications.
resource "aws_eks_cluster" "kubernetes_cluster" {   
  name = var.cluster_name
  
  # EKS supports two authentication modes: API and IAM. 
  # API mode uses the Kubernetes API server for authentication, while IAM mode uses AWS IAM for authentication.
  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster.arn # EKS Cluster requires an IAM Role with specific permissions to manage AWS resources on behalf of the cluster. This role is used by EKS to create and manage resources such as EC2 instances, load balancers, and security groups.
  version  = "1.34" #Eks cluster one version release prior to latest in K8s per task req.

  vpc_config {
    subnet_ids = var.subnets
    #EKS req public subnets for cluster endpoint access, even if worker nodes are in private subnets.
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

# EKS Cluster requires an IAM Role with specific permissions to manage AWS resources on behalf of the cluster. This role is used by EKS to create and manage resources such as EC2 instances, load balancers, and security groups. The assume_role_policy defines the trust relationship, allowing EKS to assume this role. The attached policy grants the necessary permissions for EKS to manage cluster resources effectively.
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# The AmazonEKSClusterPolicy is an AWS managed policy that provides the necessary permissions for EKS to manage cluster resources effectively. By attaching this policy to the IAM role, you ensure that EKS has the required permissions to create and manage resources such as EC2 instances, load balancers, and security groups on behalf of the cluster.
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

