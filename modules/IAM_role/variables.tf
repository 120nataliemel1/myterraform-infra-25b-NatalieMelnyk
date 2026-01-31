variable "name" {
  type        = string
  description = "Name of the IAM role"
}


variable "action" {
  type = list(string)
  description = "IAM policy action"
}

variable "resource" {
  type        = list(string)
  description = "Resources the policy applies to"
}

variable "principal_type" {
  type    = string
  description = "Either 'Service' or 'AWS'"
  default = "Service"
}

variable "principal" {
  type        = string
  description = "ARN of IAM user/role or service name"
}

variable "enable_secrets_deny" {
  type = bool
  description = "Conditional deny or allow for secrets"
  default = true
}