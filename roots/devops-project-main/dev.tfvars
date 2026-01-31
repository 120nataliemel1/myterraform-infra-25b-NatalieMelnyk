greeting = "Hi"

allocated_storage    = 20
engine              = "mysql"
engine_version      = "8.4"
instance_class      = "db.t3.micro"
db_name             = "devdb"
username            = "devuser"
password            = "devpass123"
parameter_group_name = "default.mysql8.0"
publicly_accessible = true
db_subnet_group_name = "dev-subnet-group"
vpc_security_group_ids = ["sg-12345678"]
multi_az            = false
storage_type        = "gp2"
tags = {
  Project = "MyProject"
  Owner   = "DevTeam"
  Env     = "development"
}
