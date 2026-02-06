variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "subnets" {
  type        = list(string)
  description = "List of public subnet IDs for EKS cluster VPC configuration"
  
}


#categorize variables based on resources
