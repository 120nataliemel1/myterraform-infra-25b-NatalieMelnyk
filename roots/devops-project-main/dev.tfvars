greeting = "Hi"

project_name = "projectx"
vpc_cidr     = "10.0.0.0/16"
azs          = ["us-east-1a", "us-east-1b", "us-east-1c"]

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

gha_role_arn = "arn:aws:iam::383585068161:role/GitHubActionsTerraformIAMrole"
oidc_provider_arn = "arn:aws:iam::383585068161:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/54DB0C2CC3725BB99B9E8454511E946E"

cluster_name      = "kubernetes_cluster"
ec2_types         = ["t3.medium"]


environment               = "Dev"
trusted_parent_account_id = ["arn:aws:iam::879500880845:root"]
DeveloperAccessRolePolicy = "DeveloperDevAccessRole.json"
DevopAccessRolePolicy     = "DevopsDevAccessRole.json"
