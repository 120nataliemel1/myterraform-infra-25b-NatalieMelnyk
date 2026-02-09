# Worker Node IAM (so EC2 nodes can join EKS + pull images) 

# EKS worker nodes must assume a role so AWS knows what they’re allowed to do. 
# This role needs permissions to join the EKS cluster and pull container images from Amazon ECR. 
# The assume_role_policy allows EC2 instances to assume this role, while the attached policies grant 
# the necessary permissions for worker nodes to function properly within the EKS cluster.
resource "aws_iam_role" "workers_role" {
  name = "${var.cluster_name}-workers-iam-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# lets nodes talk to EKS and function as workers. 
resource "aws_iam_role_policy_attachment" "workers_role-AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.workers_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# lets the CNI plugin manage pod networking (IPs/ENIs). Without this, pods would not get network connectivity and fail to start.
resource "aws_iam_role_policy_attachment" "workers_role-AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.workers_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# lets nodes pull container images from ECR. Without this, nodes would not be able to pull images from ECR and pods would fail to start if they use ECR images.
resource "aws_iam_role_policy_attachment" "workers_role-AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.workers_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# The “wrapper” EC2 needs to actually use the IAM role. This is done by creating an instance profile and associating it with the role. 
# The instance profile allows EC2 instances to assume the IAM role when they are launched, granting them the permissions defined in the role's policies.
# Launch Templates attach an instance profile, not the role directly.
resource "aws_iam_instance_profile" "workers_instance_profile" {
  name = "${var.cluster_name}-workers-instance-profile"
  role = aws_iam_role.workers_role.name
}


# Cluster role & policy attachment:
# EKS Cluster requires an IAM Role with specific permissions to manage AWS resources on behalf of the cluster.
# This role is used by EKS to create and manage resources such as EC2 instances, load balancers, and security groups. 
# The assume_role_policy defines the trust relationship, allowing EKS to assume this role. 
# The attached policy grants the necessary permissions for EKS to manage cluster resources effectively.
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

# The AmazonEKSClusterPolicy is an AWS managed policy that provides the necessary permissions for EKS to manage cluster resources effectively. 
# By attaching this policy to the IAM role, you ensure that EKS has the required permissions to create and manage resources such as EC2 instances, load balancers, and security groups on behalf of the cluster.
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}


resource "aws_iam_role_policy_attachment" "eks_service_policy_attachment" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arniam:policy/AmazonEKSServicePolicy"
}