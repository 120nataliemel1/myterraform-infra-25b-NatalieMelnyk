variable "greeting" {
  description = "A greeting phrase"
}

variable "trusted_parent_account_id" {
  type        = string
  description = "ARN of trusted account"
}

variable "DevopAccessRolePolicy" {
  type = string
  description = "Name of correct json file name"
}


variable "DeveloperAccessRolePolicy" {
  type = string
  description = "Name of correct json file name"
}

variable "environment" {
  type = string
  description = "Environment where resourse is created"
}