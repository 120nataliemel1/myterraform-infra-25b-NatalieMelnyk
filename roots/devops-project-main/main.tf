#DO NOT REMOVE DUMMY MODULE references and their code, they should remain as examples
module "module1" {
  source = "../../dummy-module-1"
  # ... any required variables for module1
  greeting = var.greeting

}

module "module2" {
  source = "../../dummy-module-2"

  input_from_module1 = module.module1.greeting_message
  # ... any other required variables for module2
}

module "vpc-module" {
  count                = var.enable_condition ? 1 : 0
  source               = "../../vpc-module"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment          = var.environment
}

module "eks-module" {
  count  = var.enable_condition ? 1 : 0
  source = "../../eks-module"

  cluster_name      = var.cluster_name
  subnets           = module.vpc-module.public_subnet_ids
  ec2_types         = var.ec2_types
  gha_role_arn      = var.gha_role_arn
  oidc_provider_arn = var.oidc_provider_arn

}

module "hands-on-eks-module" {
  count  = var.enable_condition ? 1 : 0
  source = "../../hands-on-eks-module"

  cluster_name        = var.cluster_name
  public_subnet_cidrs = var.public_subnet_cidrs
  public_subnet_ids   = module.vpc-module.public_subnet_ids
  vpc_id              = module.vpc-module.vpc_id
}


module "developer_iam_role" {
  count          = var.enable_condition ? 1 : 0
  source         = "../../IAM-role-module"
  environment    = var.environment
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "Developer${var.environment}AccessRole-ubuntu25b"
  policy_json    = var.DeveloperAccessRolePolicy
}

module "devops_iam_role" {
  count          = var.enable_condition ? 1 : 0
  source         = "../../IAM-role-module"
  environment    = var.environment
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "Devops${var.environment}AccessRole-ubuntu25b"
  policy_json    = var.DevopAccessRolePolicy
}

module "developer_prod_role" {
  count          = var.enable_condition ? 1 : 0
  source         = "../../IAM-role-module"
  environment    = "Prod"
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "DeveloperProdAccessRole-ubuntu25b"
  policy_json    = "DeveloperProdAccessRole.json"
}

module "devops_prod_role" {
  count          = var.enable_condition ? 1 : 0
  source         = "../../IAM-role-module"
  environment    = "Prod"
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "DevopsProdAccessRole-ubuntu25b"
  policy_json    = "DevopsProdAccessRole.json"
}

module "documentdb" {
  count              = var.enable_condition ? 1 : 0
  source             = "../../documentdb-module"
  vpc_id             = module.vpc-module.vpc_id
  private_subnet_ids = module.vpc-module.private_subnet_ids
  eks_node_sg_id     = module.eks-module.node_security_group_id
  environment        = var.environment
  name_prefix        = var.name_prefix
  instance_count     = var.instance_count
  instance_class     = var.instance_class
  tags               = var.tags
  master_username    = var.master_username
}
