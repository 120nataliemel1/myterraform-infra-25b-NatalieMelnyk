greeting = "Hi"

identifier           = "versus-db-dev"
engine               = "mysql"
engine_version       = "8.4"
instance_class       = "db.t4g.micro"
db_name              = "versus"
username             = "admin"
password             = "versus/dev"
parameter_group_name = "default.mysql8.4"
publicly_accessible  = false
db_subnet_group_name = "dev-subnet-group"
db_subnet_ids        = ["subnet-0b9f8f01bcdd24cfe", "subnet-04f9d204bd31f1878"]
# db_subnet_ids = [ "subnet-0f38ddef4171ba729", "subnet-040b2465cc502013c" ]
vpc_security_group_ids = ["sg-12345678"]
db_security_group_name = "versus-dev-rds-mysql-sg"
vpc_id                 = "vpc-017e0d248e036e59f"
# vpc_id = "vpc-0a0dfbedde5134447"
app_security_group_id = "sg-051b38478a183ce54"
# app_security_group_id = "sg-0275f7f3204636960"
multi_az                   = false
storage_type               = "gp3"
allocated_storage          = 20
db_backup_retention_period = 1
db_backup_window           = "02:00-04:00"
tags = {
  Project = "Versus"
  Owner   = "312-school-Altynai"
  Env     = "development"
}


