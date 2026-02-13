greeting = "Hi"

environment               = "Prod"
trusted_parent_account_id = ["arn:aws:iam::879500880845:root"]
DeveloperAccessRolePolicy = "DeveloperProdAccessRole.json"
DevopsAccessRolePolicy    = "DevopsProdAccessRole.json"

#DocumentDb 
master_username    = "proshop_admin"
name_prefix        = "proshop"
vpc_id             = "vpc-0ebb2e27ffc0e0584"
private_subnet_ids = ["subnet-0655f403f4ce810b2", "subnet-0bbe4b27c245a2d1f", "subnet-0733500c197e996ee"]
eks_node_sg_id     = "sg-0f3035691ecb601b4"
instance_class     = "db.t3.medium"
instance_count     = 1
tags = {
  Project     = "proshop"
  Environment = "prod"
}
