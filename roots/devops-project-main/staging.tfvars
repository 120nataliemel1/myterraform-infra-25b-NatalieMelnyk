greeting = "Hi"

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

environment   = "staging"
enable_addons = true

trusted_parent_account_id = ["arn:aws:iam::879500880845:root"]
DeveloperAccessRolePolicy = "DeveloperDevAccessRole.json"
DevopAccessRolePolicy     = "DevopsDevAccessRole.json"
