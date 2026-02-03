
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "db_name" {}
variable "username" {}
variable "db_password" {}
variable "parameter_group_name" {}
variable "publicly_accessible" {}
variable "db_subnet_group_name" {}
variable "db_subnet_ids" { type = list(string) }
variable "vpc_security_group_ids" { type = list(string) }
variable "db_security_group_name" { type = string }
variable "vpc_id" { type = string }
variable "app_security_group_id" { type = string }  
variable "multi_az" {}
variable "storage_type" {}
variable "allocated_storage" {}
variable "db_backup_retention_period" {}
variable "db_backup_window" {}
variable "tags" { type = map(string) }
