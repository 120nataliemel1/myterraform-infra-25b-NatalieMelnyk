variable "allocated_storage" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "db_name" {}
variable "username" {}
variable "password" {}
variable "parameter_group_name" {}
variable "publicly_accessible" { default = false }
variable "db_subnet_group_name" {}
variable "vpc_security_group_ids" { type = list(string) }
variable "multi_az" { default = false }
variable "storage_type" { default = "gp2" }
variable "tags" { type = map(string) }
