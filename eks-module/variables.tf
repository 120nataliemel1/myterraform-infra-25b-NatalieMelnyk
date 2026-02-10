variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "subnets" {
  type        = list(string)
  description = "List of public subnet IDs for EKS cluster VPC configuration"

}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the EKS cluster will be deployed"

} # no need to declare in dev.tfvars since we will get it from vpc-module output in root/main.tf

variable "project_name" {
  type        = string
  description = "Project name for tagging and naming resources"

}

variable "environment" {
  type        = string
  description = "Environment name (e.g., Dev, Prod) for tagging and naming resources"

}

variable "k8s_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster (e.g., 1.34)"
  
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