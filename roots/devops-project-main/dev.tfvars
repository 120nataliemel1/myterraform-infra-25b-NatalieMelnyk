greeting = "Hi"

# AWS RDS MySQL Variables
identifier                 = "versus-db-dev"
engine                     = "mysql"
engine_version             = "8.4"
instance_class             = "db.t4g.micro"
db_name                    = "versus"
username                   = "admin"
parameter_group_name       = "default.mysql8.4"
publicly_accessible        = false
db_subnet_group_name       = "dev-subnet-group"
db_subnet_ids              = ["subnet-0655f403f4ce810b2", "subnet-0bbe4b27c245a2d1f", "subnet-0733500c197e996ee"]
db_security_group_name     = "versus-dev-rds-mysql-sg"
vpc_id                     = "vpc-0ebb2e27ffc0e0584"
app_security_group_id      = "sg-0a440c2ce616c1c31"
multi_az                   = false
storage_type               = "gp3"
allocated_storage          = 20
db_backup_retention_period = 1
deletion_protection        = false
db_backup_window           = "02:00-04:00"

tags = {
  Project = "Versus"
  Owner   = "312-school-Altynai"
  Env     = "development"
}

# AWS RDS MySQL CloudWatch Alarm Variables
alarm_name     = "versus-dev-rds-cpu-high"
cpu_threshold  = 80
rds_cpu_alerts = "versus-dev-rds-cpu-alerts"