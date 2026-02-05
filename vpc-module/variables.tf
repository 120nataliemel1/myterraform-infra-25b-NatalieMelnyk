variable "project_name" {
  type        = string
  description = "Used for naming/tagging resources"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC (ex: 10.0.0.0/16)"
}

variable "azs" {
  type        = list(string)
  description = "List of AZs to place subnets in (ex: [us-east-1a, us-east-1b, us-east-1c])"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDRs for public subnets (3 items)"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDRs for private subnets (3 items)"
}

variable "environment" {
  type        = string
  description = "Environment for the resources (ex: dev, prod)"
}