greeting = "Hi"

# AWS RDS MySQL Variables
identifier                 = "versus-db-staging"
engine                     = "mysql"
engine_version             = "8.4"
instance_class             = "db.t4g.micro"
db_name                    = "versus"
username                   = "admin"
db_password                = "versus/staging"
parameter_group_name       = "default.mysql8.4"
publicly_accessible        = false
db_subnet_group_name       = "staging-subnet-group"
db_subnet_ids              = ["subnet-0f38ddef4171ba729", "subnet-040b2465cc502013c"]
vpc_security_group_ids     = ["sg-12345678"]
db_security_group_name     = "versus-staging-rds-mysql-sg"
vpc_id                     = "vpc-0a0dfbedde5134447"
app_security_group_id      = "sg-0275f7f3204636960"
multi_az                   = true
storage_type               = "gp3"
allocated_storage          = 100
db_backup_retention_period = 30
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