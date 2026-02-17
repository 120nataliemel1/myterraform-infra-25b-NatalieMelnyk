greeting = "Hi"

# AWS RDS MySQL Variables
identifier                 = "versus-db-staging"
engine                     = "mysql"
engine_version             = "8.4"
versus_app_instance_class  = "db.r6g.xlarge"
db_name                    = "versus"
username                   = "admin"
parameter_group_name       = "default.mysql8.4"
publicly_accessible        = false
db_subnet_group_name       = "staging-subnet-group"
db_subnet_ids              = ["subnet-0d43516578e7d7c7b", "subnet-06054cb3cddc77fe3", "subnet-053709f833b94529c"]
db_security_group_name     = "versus-staging-rds-mysql-sg"
vpc_id                     = "vpc-0ebb2e27ffc0e0584"
app_security_group_id      = "sg-011baa13c24c54a02"
multi_az                   = true
storage_type               = "gp3"
allocated_storage          = 100
db_backup_retention_period = 3
deletion_protection        = true
db_backup_window           = "02:00-04:00"

tags_versus_app = {
  Project = "Versus"
  Owner   = "312-school-Altynai"
  Env     = "staging"
}

# AWS RDS MySQL CloudWatch Alarm Variables
alarm_name     = "versus-staging-rds-cpu-high"
cpu_threshold  = 80
rds_cpu_alerts = "versus-staging-rds-cpu-alerts"
#DocumentDb 
master_username = "proshop_admin"
name_prefix     = "proshop"
environment     = "stage"
eks_node_sg_id  = "sg-0415e8ef8236558de"
instance_class  = "db.t3.medium"
instance_count  = 1
tags = {
  Project     = "proshop"
  Environment = "stage"
}
project_name = "projectx_ubuntu25b"
cluster_name = "projectx_cluster_ubuntu25b"

vpc_cidr = "10.0.0.0/16"
azs      = ["us-east-1a", "us-east-1b", "us-east-1c"]

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

ec2_types        = ["t3.medium", "t3a.medium", "t2.medium"]
k8s_version      = "1.34"
min_size         = 1
max_size         = 5
desired_capacity = 2

enable_addons = true

trusted_parent_account_id = ["arn:aws:iam::879500880845:root"]
DeveloperAccessRolePolicy = "DeveloperDevAccessRole.json"
DevopAccessRolePolicy     = "DevopsDevAccessRole.json"
environment            = "stage"
hosted_zone_names        = ["312ubuntu.com."]
cluster_name           = "temp-eks-cluster"
external_dns_namespace = "external-dns"
external_dns_sa_name   = "external-dns"
