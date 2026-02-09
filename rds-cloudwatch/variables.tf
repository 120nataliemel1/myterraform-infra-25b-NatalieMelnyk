variable "alarm_name" {
  type        = string
  description = "Name of the CloudWatch alarm"
}

variable "identifier" {
  type        = string
  description = "RDS instance identifier"
}

variable "cpu_threshold" {
  type        = number
  default     = 80
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources"
}

variable "rds_cpu_alerts" {
    type        = string
    description = "Name of the SNS topic for RDS CPU alerts"
}