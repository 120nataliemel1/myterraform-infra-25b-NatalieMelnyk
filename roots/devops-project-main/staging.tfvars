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
