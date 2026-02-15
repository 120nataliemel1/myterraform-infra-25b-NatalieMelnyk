greeting = "Hi"

# AWS RDS MySQL Variables
identifier                 = "versus-db-staging"
engine                     = "mysql"
engine_version             = "8.4"
instance_class             = "db.r6g.xlarge"
db_name                    = "versus"
username                   = "admin"
parameter_group_name       = "default.mysql8.4"
publicly_accessible        = false
db_subnet_group_name       = "staging-subnet-group"
db_subnet_ids              = ["subnet-00d92efb24e2262bc", "subnet-0f5d1218525ef8b57", "subnet-072f82ea73aafea1d"]
db_security_group_name     = "versus-staging-rds-mysql-sg"
vpc_id                     = "vpc-0ebb2e27ffc0e0584"
app_security_group_id      = "sg-0676a84ea39bc0b13"
multi_az                   = true
storage_type               = "gp3"
allocated_storage          = 100
db_backup_retention_period = 3
deletion_protection        = true
db_backup_window           = "02:00-04:00"

tags = {
  Project = "Versus"
  Owner   = "312-school-Altynai"
  Env     = "staging"
}

# AWS RDS MySQL CloudWatch Alarm Variables
alarm_name     = "versus-staging-rds-cpu-high"
cpu_threshold  = 80
rds_cpu_alerts = "versus-staging-rds-cpu-alerts"