variable "greeting" {
  description = "A greeting phrase"
}
##############################
# AWS RDS MySQL Variables
##############################
variable "identifier" {
  type        = string
  description = "RDS instance identifier"
}

variable "engine" {
  type        = string
  description = "Database engine"
}

variable "engine_version" {
  type        = string
  description = "Database engine version"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class"
}

variable "db_name" {
  type        = string
  description = "Initial database name"
}

variable "username" {
  type        = string
  description = "Master database username"
}

variable "db_password" {
  type        = string
  description = "Master database password"
  sensitive   = true
}

variable "parameter_group_name" {
  type        = string
  description = "DB parameter group name"
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether the RDS instance is publicly accessible"
}

variable "db_subnet_group_name" {
  type        = string
  description = "RDS DB subnet group name"
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the DB subnet group"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Security group IDs attached to the RDS instance"
}

variable "db_security_group_name" {
  type        = string
  description = "Name of the RDS security group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where RDS is deployed"
}

variable "app_security_group_id" {
  type        = string
  description = "Application security group allowed to access RDS"
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment"
}

variable "storage_type" {
  type        = string
  description = "Storage type"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage size in GB"
}

variable "db_backup_retention_period" {
  type        = number
  description = "Number of days to retain backups"
}

variable "db_backup_window" {
  type        = string
  description = "Preferred backup window (UTC)"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources"
}

###########################################
# AWS RDS MySQL CloudWatch Alarm Variables
###########################################
variable "alarm_name" {
  type        = string
  description = "Name of the CloudWatch alarm"
  
}

variable "cpu_threshold" {
  type        = number
  default     = 80
}

variable "rds_cpu_alerts" {
    type        = string
    description = "Name of the SNS topic for RDS CPU alerts"
}