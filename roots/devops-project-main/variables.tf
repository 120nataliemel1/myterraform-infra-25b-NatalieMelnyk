variable "greeting" {
  description = "A greeting phrase"
}

variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "ec2_types" {
  type        = list(string)
  description = "Instance types for EKS worker nodes"
  default     = ["t3.medium"]
}

variable "gha_role_arn" {
  type        = string
  description = "IAM role ARN used by GitHub Actions (OIDC) to deploy to EKS"
}

variable "oidc_provider_arn" {
  type        = string
  description = "IAM OIDC provider ARN for this EKS cluster"
}

variable "trusted_parent_account_id" {
  type        = list(string)
  description = "ARN of trusted account"
}

variable "DevopAccessRolePolicy" {
  type        = string
  description = "Name of correct json file name"
}


variable "DeveloperAccessRolePolicy" {
  type        = string
  description = "Name of correct json file name"
}

variable "environment" {
  type        = string
  description = "Environment where resourse is created"
}
