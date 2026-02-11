# #DO NOT REMOVE DUMMY MODULE references and their code, they should remain as examples
# module "module1" {
#   source = "../../dummy-module-1"
#   # ... any required variables for module1
#   greeting = var.greeting

# }

# module "module2" {
#   source = "../../dummy-module-2"

#   input_from_module1 = module.module1.greeting_message
#   # ... any other required variables for module2
# }

# module "vpc-module" {
#   source               = "../../vpc-module"
#   project_name         = var.project_name
#   vpc_cidr             = var.vpc_cidr
#   azs                  = var.azs
#   public_subnet_cidrs  = var.public_subnet_cidrs
#   private_subnet_cidrs = var.private_subnet_cidrs
#   environment          = var.environment
#   cluster_name         = var.cluster_name
# }

# module "eks-module" {
#   source       = "../../eks-module"
#   cluster_name = var.cluster_name
#   vpc_id       = module.vpc-module.vpc_id
#   subnets      = module.vpc-module.public_subnet_ids_ordered

#   vpc_cidr     = var.vpc_cidr
#   ec2_types    = var.ec2_types
#   project_name = var.project_name
#   environment  = var.environment
#   k8s_version  = var.k8s_version

#   min_size         = var.min_size
#   max_size         = var.max_size
#   desired_capacity = var.desired_capacity
#   enable_addons    = var.enable_addons
# }

# module "developer_iam_role" {
#   source         = "../../IAM-role-module"
#   environment    = var.environment
#   principal_type = "AWS"
#   principal      = var.trusted_parent_account_id
#   role_name      = "Developer${var.environment}AccessRole-ubuntu25b"
#   policy_json    = var.DeveloperAccessRolePolicy
# }

# module "devops_iam_role" {
#   source         = "../../IAM-role-module"
#   environment    = var.environment
#   principal_type = "AWS"
#   principal      = var.trusted_parent_account_id
#   role_name      = "Devops${var.environment}AccessRole-ubuntu25b"
#   policy_json    = var.DevopAccessRolePolicy
# }

# module "developer_prod_role" {
#   source         = "../../IAM-role-module"
#   environment    = "Prod"
#   principal_type = "AWS"
#   principal      = var.trusted_parent_account_id
#   role_name      = "DeveloperProdAccessRole-ubuntu25b"
#   policy_json    = "DeveloperProdAccessRole.json"
# }

# module "devops_prod_role" {
#   source         = "../../IAM-role-module"
#   environment    = "Prod"
#   principal_type = "AWS"
#   principal      = var.trusted_parent_account_id
#   role_name      = "DevopsProdAccessRole-ubuntu25b"
#   policy_json    = "DevopsProdAccessRole.json"
# }

# module "documentdb" {
#   source                  = "../../documentdb-module"
#   vpc_id                  = module.vpc-module.vpc_id
#   private_subnet_ids      = module.vpc-module.private_subnet_ids_ordered
#   node_security_group_id  = module.eks-module.node_security_group_id
#   environment             = var.environment
#   name_prefix             = var.name_prefix
#   instance_count          = var.instance_count
#   mongo_db_instance_class = var.mongo_db_instance_class
#   tags_proshop            = var.tags_proshop
#   master_username         = var.master_username
# }

# ###########################################
# # RDS MySQL
# ###########################################
# module "rds_mysql" {
#   source = "../../rds-mysql-module"

#   identifier                 = var.identifier
#   allocated_storage          = var.allocated_storage
#   engine                     = var.engine
#   engine_version             = var.engine_version
#   versus_app_instance_class  = var.versus_app_instance_class
#   db_name                    = var.db_name
#   username                   = var.username
#   parameter_group_name       = var.parameter_group_name
#   publicly_accessible        = var.publicly_accessible
#   db_subnet_group_name       = var.db_subnet_group_name
#   db_subnet_ids              = module.vpc-module.private_subnet_ids_ordered
#   db_security_group_name     = var.db_security_group_name
#   vpc_id                     = module.vpc-module.vpc_id
#   app_security_group_id      = module.eks-module.node_security_group_id
#   multi_az                   = var.multi_az
#   storage_type               = var.storage_type
#   db_backup_retention_period = var.db_backup_retention_period
#   deletion_protection        = var.deletion_protection
#   db_backup_window           = var.db_backup_window

#   tags_versus_app = var.tags_versus_app
# }

# ###########################################
# # CloudWatch Alarms for RDS
# ###########################################
# module "rds_cloudwatch" {
#   source = "../../rds-cloudwatch-module"

#   alarm_name     = var.alarm_name
#   identifier     = var.identifier
#   cpu_threshold  = var.cpu_threshold
#   rds_cpu_alerts = var.rds_cpu_alerts

#   tags_versus_app = var.tags_versus_app
# }

# ####################################################
# # EXTERNAL-DNS   
# ####################################################

# data "aws_route53_zone" "selected" {
#   for_each     = toset(var.hosted_zone_names)
#   name         = each.value
#   private_zone = false
# }

# module "external_dns_irsa" {
#   source = "../../external-dns-irsa"

#   environment          = var.environment
#   cluster_name         = module.eks-module.cluster_name
#   hosted_zone_ids      = [for z in data.aws_route53_zone.selected : z.zone_id]
#   oidc_arn             = module.eks-module.oidc_provider_arn
#   oidc_url             = module.eks-module.cluster_oidc_issuer
#   namespace            = var.external_dns_namespace
#   service_account_name = var.external_dns_sa_name
# }

# # data "aws_eks_cluster" "eks_cluster" {
# #   name = var.cluster_name
# # }
# # data "aws_iam_openid_connect_provider" "eks_cluster" {
# #   url = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
# # }

# # data "aws_route53_zone" "selected" {
# #   for_each     = toset(var.hosted_zone_names)
# #   name         = each.value
# #   private_zone = false
# # }

# # module "external_dns_irsa" {
# #   source = "../../external-dns-irsa"

# #   environment          = var.environment
# #   cluster_name         = var.cluster_name
# #   hosted_zone_ids      = [for z in data.aws_route53_zone.selected : z.zone_id]
# #   oidc_arn             = data.aws_iam_openid_connect_provider.eks_cluster.arn
# #   oidc_url             = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
# #   namespace            = var.external_dns_namespace
# #   service_account_name = var.external_dns_sa_name
# # }

####################################################
# KARPENTER
####################################################

data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}
data "aws_iam_openid_connect_provider" "eks_cluster" {
  url = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

module "karpenter_irsa" {
  source = "../../karpenter"

  environment          = var.environment
  region               = var.region
  cluster_name         = var.cluster_name
  namespace            = var.karpenter_namespace
  service_account_name = var.karpenter_sa_name
  oidc_arn             = data.aws_iam_openid_connect_provider.eks_cluster.arn
  oidc_url             = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}
