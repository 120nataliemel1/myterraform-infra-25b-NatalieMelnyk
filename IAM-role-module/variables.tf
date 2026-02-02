variable "role_name" {
  type        = string
  description = "Name of the IAM role"
}

variable "principal_type" {
  type        = string
  description = "Either 'Service' or 'AWS'"
  default     = "Service"
}

variable "principal" {
  type        = list(string)
  description = "ARN of IAM user/role or service name"
}

variable "policy_json" {
  type        = string
  description = "Name policy json file"
}

variable "environment" {
  type        = string
  description = "Environment where resourse is created"
}