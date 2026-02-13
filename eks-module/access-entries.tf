############################################
# EKS Access Entries (EKS API-based access)
############################################

# Worker nodes -> cluster auth (replaces aws-auth role mapping)
resource "aws_eks_access_entry" "nodes_entry" {
  cluster_name      = aws_eks_cluster.projectx_cluster.name
  principal_arn     = aws_iam_role.workers_role.arn
  type              = "EC2_LINUX"
}

# Human admin (AWS SSO role) -> cluster-admin
resource "aws_eks_access_entry" "sso_admin" {
  cluster_name  = aws_eks_cluster.projectx_cluster.name
  principal_arn = "arn:aws:iam::383585068161:role/aws-reserved/sso.amazonaws.com/us-east-2/AWSReservedSSO_AdministratorAccess_b18a1488d07743cc"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "sso_admin_cluster_admin" {
  cluster_name  = aws_eks_cluster.projectx_cluster.name
  principal_arn = aws_eks_access_entry.sso_admin.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope { type = "cluster" }

  depends_on = [aws_eks_access_entry.sso_admin]
}

# GitHub Actions Terraform role -> cluster-admin
resource "aws_eks_access_entry" "github_terraform" {
  cluster_name  = aws_eks_cluster.projectx_cluster.name
  principal_arn = "arn:aws:iam::383585068161:role/GitHubActionsTerraformIAMrole"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_terraform_cluster_admin" {
  cluster_name  = aws_eks_cluster.projectx_cluster.name
  principal_arn = aws_eks_access_entry.github_terraform.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope { type = "cluster" }

  depends_on = [aws_eks_access_entry.github_terraform]
}

# GitHub Actions deploy role -> cluster-admin (tighten later if needed)
resource "aws_eks_access_entry" "github_eks_deploy" {
  cluster_name  = aws_eks_cluster.projectx_cluster.name
  principal_arn = "arn:aws:iam::383585068161:role/GitHubActionsEKSDeploymentRole"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_eks_deploy_cluster_admin" {
  cluster_name  = aws_eks_cluster.projectx_cluster.name
  principal_arn = aws_eks_access_entry.github_eks_deploy.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope { type = "cluster" }

  depends_on = [aws_eks_access_entry.github_eks_deploy]
}

