variable "greeting" {
  description = "A greeting phrase"
}

### General/Global Variables ###

variable "project_name" {
  type = string
}

variable "environment" {
  type        = string
  description = "Environment where resourse is created"
}

###### VPC variables ######

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

### EKS Cluster Variables (control plane configuration) ###

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "subnets" {
  type        = list(string)
  description = "List of public subnet IDs for EKS cluster VPC configuration"

}

variable "k8s_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster (e.g., 1.34)"

}

### EKS Worker / Compute Variables (nodes, LT, ASG) ###

variable "ec2_types" {
  type        = list(string)
  description = "Instance types for EKS worker nodes"
  default     = ["t3.medium"]
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of worker nodes in the EKS cluster"
  default     = 2

}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes in the EKS cluster"
  default     = 5

}

variable "min_size" {
  type        = number
  description = "Minimum number of worker nodes in the EKS cluster"
  default     = 1

}

### IAM / Security Variables (roles, trust, access) ###

variable "gha_role_arn" {
  type        = string
  description = "IAM role ARN used by GitHub Actions (OIDC) to deploy to EKS"
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

variable "enable_addons" {
  type    = bool
  default = false
}
