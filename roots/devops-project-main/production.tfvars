greeting = "Hi"

environment               = "prod"
trusted_parent_account_id = ["arn:aws:iam::879500880845:root"]
DeveloperAccessRolePolicy = "DeveloperProdAccessRole.json"
DevopsAccessRolePolicy    = "DevopsProdAccessRole.json"

#DocumentDb 
master_username    = "proshop_admin"
name_prefix        = "proshop"
eks_node_sg_id     = "sg-0f3035691ecb601b4"
instance_class     = "db.t3.medium"
instance_count     = 1
tags = {
  Project     = "proshop"
  Environment = "prod"
}
