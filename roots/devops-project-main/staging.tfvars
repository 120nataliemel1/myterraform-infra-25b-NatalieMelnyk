greeting = "Hi"

#DocumentDb 
master_username    = "proshop_admin"
name_prefix        = "proshop"
environment        = "stage"
vpc_id             = "vpc-0a0dfbedde5134447"
private_subnet_ids = ["subnet-0860a697936586558", "subnet-0942387a6e8da1501", "subnet-038a521ea0dc16ebb"]
eks_node_sg_id     = "sg-0415e8ef8236558de"
instance_class     = "db.t3.medium"
instance_count     = 1
tags = {
  Project     = "proshop"
  Environment = "stage"
}
