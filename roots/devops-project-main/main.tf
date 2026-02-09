# DO NOT REMOVE DUMMY MODULE references and their code, they should remain as examples
module "module1" {
  source = "../../dummy-module-1"
  # ... any required variables for module1
  greeting = var.greeting

}

module "module2" {
  source = "../../dummy-module-2"

  input_from_module1 = module.module1.greeting_message
  # ... any other required variables for module2
}

###########################################
# RDS MySQL
###########################################
module "rds_mysql" {
  source = "../../rds-mysql"

  identifier                 = var.identifier
  allocated_storage          = var.allocated_storage
  engine                     = var.engine
  engine_version             = var.engine_version
  instance_class             = var.instance_class
  db_name                    = var.db_name
  username                   = var.username
  db_password                = var.db_password
  parameter_group_name       = var.parameter_group_name
  publicly_accessible        = var.publicly_accessible
  db_subnet_group_name       = var.db_subnet_group_name
  db_subnet_ids              = var.db_subnet_ids
  vpc_security_group_ids     = var.vpc_security_group_ids
  db_security_group_name     = var.db_security_group_name
  vpc_id                     = var.vpc_id
  app_security_group_id      = var.app_security_group_id
  multi_az                   = var.multi_az
  storage_type               = var.storage_type
  db_backup_retention_period = var.db_backup_retention_period
  db_backup_window           = var.db_backup_window

  tags = var.tags
}

###########################################
# CloudWatch Alarms for RDS
###########################################
module "rds_cloudwatch" {
  source = "../../rds-cloudwatch"

  alarm_name     = var.alarm_name
  identifier     = var.identifier
  cpu_threshold  = var.cpu_threshold
  rds_cpu_alerts = var.rds_cpu_alerts

  tags = var.tags
}