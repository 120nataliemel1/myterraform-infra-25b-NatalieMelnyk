############################################
# EKS Access Entries (modern access control)
# Purpose: grant Kubernetes RBAC access to specific IAM roles
# without relying on the legacy aws-auth ConfigMap.
############################################

# 1) AWS SSO AdministratorAccess role
# This is your human/admin identity (via AWS SSO) that should have full cluster admin.
resource "aws_eks_access_entry" "sso_admin" {
  # Target EKS cluster (uses the cluster we created in this module)
  cluster_name = aws_eks_cluster.projectx_cluster.name

  # The IAM role that represents your SSO permission set (AdministratorAccess)
  # NOTE: this is an IAM ROLE ARN, not an SSO user/group ID.
  principal_arn = "arn:aws:iam::383585068161:role/aws-reserved/sso.amazonaws.com/us-east-2/AWSReservedSSO_AdministratorAccess_b18a1488d07743cc"

  # STANDARD = normal access entry used for IAM role to Kubernetes access mapping
  type = "STANDARD"
}

# Attach an EKS-managed "cluster admin" access policy to the SSO role.
# This is what actually grants Kubernetes admin permissions.
resource "aws_eks_access_policy_association" "sso_admin_cluster_admin" {
  # Same target cluster
  cluster_name = aws_eks_cluster.projectx_cluster.name

  # Must match the same principal we created the access entry for
  principal_arn = aws_eks_access_entry.sso_admin.principal_arn

  # EKS cluster access policy (NOT IAM AdministratorAccess)
  # Grants full cluster-admin RBAC inside Kubernetes.
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  # Cluster scope = permissions apply across the whole cluster
  access_scope {
    type = "cluster"
  }
}

############################################
# 2) GitHub Actions Terraform role
# This role runs Terraform via GitHub Actions and needs cluster admin
# so it can create/update cluster resources (addons, access, etc.).
############################################
resource "aws_eks_access_entry" "github_terraform" {
  # Target EKS cluster
  cluster_name = aws_eks_cluster.projectx_cluster.name

  # IAM role assumed by GitHub Actions when running Terraform
  principal_arn = "arn:aws:iam::383585068161:role/GitHubActionsTerraformIAMrole"

  # Standard access entry for IAM role -> Kubernetes access
  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_terraform_cluster_admin" {
  # Same target cluster
  cluster_name = aws_eks_cluster.projectx_cluster.name

  # Must match the same principal as the access entry above
  principal_arn = aws_eks_access_entry.github_terraform.principal_arn

  # Give this role cluster-admin so Terraform automation isn't blocked
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  # Permissions apply cluster-wide
  access_scope {
    type = "cluster"
  }
}

############################################
# 3) GitHub Actions EKS Deployment role
# This role is used for CI/CD deployments (kubectl/helm apply).
# Giving cluster-admin is simplest for the project; you can reduce later.
############################################
resource "aws_eks_access_entry" "github_eks_deploy" {
  # Target EKS cluster
  cluster_name = aws_eks_cluster.projectx_cluster.name

  # IAM role assumed by GitHub Actions for EKS deployments
  principal_arn = "arn:aws:iam::383585068161:role/GitHubActionsEKSDeploymentRole"

  # Standard access entry for IAM role -> Kubernetes access
  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_eks_deploy_cluster_admin" {
  # Same target cluster
  cluster_name = aws_eks_cluster.projectx_cluster.name

  # Must match the same principal as the access entry above
  principal_arn = aws_eks_access_entry.github_eks_deploy.principal_arn

  # Cluster-admin permissions for deployments (simple + unblocked)
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  # Permissions apply cluster-wide
  access_scope {
    type = "cluster"
  }
}
