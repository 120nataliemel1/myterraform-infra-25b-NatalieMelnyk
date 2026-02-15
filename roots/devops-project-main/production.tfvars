greeting = "Hi"

environment               = "prod"
trusted_parent_account_id = ["arn:aws:iam::879500880845:root"]
DeveloperAccessRolePolicy = "DeveloperProdAccessRole.json"
DevopsAccessRolePolicy    = "DevopsProdAccessRole.json"

#DocumentDb 
master_username = "proshop_admin"
name_prefix     = "proshop"
instance_class  = "db.t3.medium"
instance_count  = 1
tags = {
  Project     = "proshop"
  Environment = "prod"
}
