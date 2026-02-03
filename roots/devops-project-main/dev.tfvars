greeting = "Hi"

# AWS RDS MySQL Variables
identifier                = "versus-db-dev"
engine                    = "mysql"
engine_version            = "8.4"
versus_app_instance_class = "db.t4g.micro"
db_name                   = "versus"
username                  = "admin"
parameter_group_name      = "default.mysql8.4"
publicly_accessible       = false
db_subnet_group_name      = "dev-subnet-group"
#db_subnet_ids              = ["subnet-0d43516578e7d7c7b", "subnet-06054cb3cddc77fe3", "subnet-053709f833b94529c"]
db_security_group_name = "versus-dev-rds-mysql-sg"
# vpc_id                     = "vpc-0ebb2e27ffc0e0584"
# app_security_group_id      = "sg-011baa13c24c54a02"
multi_az                   = false
storage_type               = "gp3"
allocated_storage          = 20
db_backup_retention_period = 1
deletion_protection        = false
db_backup_window           = "02:00-04:00"

tags_versus_app = {
  Project = "Versus"
  Owner   = "312-school-Altynai"
  Env     = "development"
}

# AWS RDS MySQL CloudWatch Alarm Variables
alarm_name     = "versus-dev-rds-cpu-high"
cpu_threshold  = 80
rds_cpu_alerts = "versus-dev-rds-cpu-alerts"
project_name   = "projectx_ubuntu25b"
cluster_name   = "projectx_cluster_ubuntu25b"

vpc_cidr = "10.0.0.0/16"
azs      = ["us-east-1a", "us-east-1b", "us-east-1c"]

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

ec2_types        = ["t3.medium", "t3a.medium", "t2.medium"]
k8s_version      = "1.34"
min_size         = 1
max_size         = 5
desired_capacity = 2

environment   = "dev"
enable_addons = true

trusted_parent_account_id = ["arn:aws:iam::879500880845:root"]
DeveloperAccessRolePolicy = "DeveloperDevAccessRole.json"
DevopAccessRolePolicy     = "DevopsDevAccessRole.json"

#DocumentDb 
master_username         = "proshop_admin"
name_prefix             = "proshop"
mongo_db_instance_class = "db.t3.medium"
instance_count          = 1
tags_proshop = {
  Project     = "proshop"
  Environment = "dev"
}

