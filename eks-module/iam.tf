############################################
# IAM - EKS cluster role
############################################

resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = ["sts:AssumeRole", "sts:TagSession"],
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy_attachment" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

############################################
# IAM - Worker nodes role + instance profile
############################################

resource "aws_iam_role" "workers_role" {
  name = "${var.cluster_name}-workers-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = "sts:AssumeRole",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
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

resource "aws_iam_role_policy_attachment" "ecr_poweruser_policy_attachment" {
  role       = aws_iam_role.workers_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "elb_policy_attachment" {
  role       = aws_iam_role.workers_role.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_full_access_attachment" {
  role       = aws_iam_role.workers_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Launch Templates attach an instance profile, not the role directly.
resource "aws_iam_instance_profile" "workers_instance_profile" {
  name = "${var.cluster_name}-workers-instance-profile"
  role = aws_iam_role.workers_role.name
}
