variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "name_prefix" {
  description = "Prefix used for naming DocumentDB resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where DocumentDB will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for DocumentDB subnet group"
  type        = list(string)
}

variable "eks_node_sg_id" {
  description = "Security group ID of EKS worker nodes allowed to access DocumentDB"
  type        = string
}

variable "tags" {
  description = "Common tags applied to all DocumentDB resources"
  type        = map(string)
  default     = {}
}