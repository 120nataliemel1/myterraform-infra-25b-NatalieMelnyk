greeting = "Hi"

# AWS RDS MySQL Variables
identifier                 = "versus-db-prod"
engine                     = "mysql"
engine_version             = "8.4"
versus_app_instance_class  = "db.r6g.2xlarge"
db_name                    = "versus"
username                   = "admin"
parameter_group_name       = "default.mysql8.4"
publicly_accessible        = false
db_subnet_group_name       = "prod-subnet-group"
db_subnet_ids              = ["subnet-0d43516578e7d7c7b", "subnet-06054cb3cddc77fe3", "subnet-053709f833b94529c"]
db_security_group_name     = "versus-prod-rds-mysql-sg"
vpc_id                     = "vpc-0ebb2e27ffc0e0584"
app_security_group_id      = "sg-011baa13c24c54a02"
multi_az                   = true
storage_type               = "gp3"
allocated_storage          = 200
db_backup_retention_period = 7
deletion_protection        = true
db_backup_window           = "02:00-04:00"

tags_versus_app = {
  Project = "Versus"
  Owner   = "312-school-Altynai"
  Env     = "production"
}

# AWS RDS MySQL CloudWatch Alarm Variables
alarm_name     = "versus-prod-rds-cpu-high"
cpu_threshold  = 80
rds_cpu_alerts = "versus-prod-rds-cpu-alerts"