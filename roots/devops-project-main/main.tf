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
  count             = var.enable_condition ? 1 : 0
  source               = "../../vpc-module"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment          = var.environment
  cluster_name         = var.cluster_name
}

module "eks-module" {
  count             = var.enable_condition ? 1 : 0
  source = "../../eks-module"

  cluster_name = var.cluster_name
  vpc_id       = module.vpc-module.vpc_id
  subnets      = module.vpc-module.public_subnet_ids_ordered

  vpc_cidr     = var.vpc_cidr
  ec2_types    = var.ec2_types
  project_name = var.project_name
  environment  = var.environment
  k8s_version  = var.k8s_version

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity
  enable_addons    = var.enable_addons
}

module "developer_iam_role" {
  count             = var.enable_condition ? 1 : 0
  source         = "../../IAM-role-module"
  environment    = var.environment
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "Developer${var.environment}AccessRole-ubuntu25b"
  policy_json    = var.DeveloperAccessRolePolicy
}

module "devops_iam_role" {
  count             = var.enable_condition ? 1 : 0
  source         = "../../IAM-role-module"
  environment    = var.environment
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "Devops${var.environment}AccessRole-ubuntu25b"
  policy_json    = var.DevopAccessRolePolicy
}

module "developer_prod_role" {
  count             = var.enable_condition ? 1 : 0
  source         = "../../IAM-role-module"
  environment    = "Prod"
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "DeveloperProdAccessRole-ubuntu25b"
  policy_json    = "DeveloperProdAccessRole.json"
}

module "devops_prod_role" {
  count             = var.enable_condition ? 1 : 0
  source         = "../../IAM-role-module"
  environment    = "Prod"
  principal_type = "AWS"
  principal      = var.trusted_parent_account_id
  role_name      = "DevopsProdAccessRole-ubuntu25b"
  policy_json    = "DevopsProdAccessRole.json"
}

