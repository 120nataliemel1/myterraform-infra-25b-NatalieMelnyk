variable "greeting" {
  description = "A greeting phrase"
}
variable "identifier" {}

variable "engine" {}

variable "engine_version" {}

variable "instance_class" {}

variable "db_name" {}

variable "username" {}

variable "password" {}

variable "parameter_group_name" {}

variable "publicly_accessible" {}

variable "db_subnet_group_name" {}

variable "db_subnet_ids" { type = list(string) }

variable "vpc_security_group_ids" { type = list(string) }

variable "db_security_group_name" {}

variable "vpc_id" {}

variable "app_security_group_id" {}

variable "multi_az" {}

variable "storage_type" {}

variable "allocated_storage" {}

variable "db_backup_retention_period" { type = number }

variable "db_backup_window" {}

variable "tags" { type = map(string) }
