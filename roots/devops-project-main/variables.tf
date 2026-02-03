variable "greeting" {
  description = "A greeting phrase"
}

##############################
# AWS RDS MySQL Variables
##############################
variable "identifier" {
  type        = string
  description = "RDS instance identifier"
}

variable "engine" {
  type        = string
  description = "Database engine"
}

variable "engine_version" {
  type        = string
  description = "Database engine version"
}

variable "versus_app_instance_class" {
  type        = string
  description = "RDS instance class"
}

variable "db_name" {
  type        = string
  description = "Initial database name"
}

variable "username" {
  type        = string
  description = "Master database username"
}

variable "parameter_group_name" {
  type        = string
  description = "DB parameter group name"
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether the RDS instance is publicly accessible"
}

variable "db_subnet_group_name" {
  type        = string
  description = "RDS DB subnet group name"
}

# variable "db_subnet_ids" {
#   type        = list(string)
#   description = "List of subnet IDs for the DB subnet group"
# }

variable "db_security_group_name" {
  type        = string
  description = "Name of the RDS security group"
}

# variable "vpc_id" {
#   type        = string
#   description = "VPC ID where RDS is deployed"
# }

# variable "app_security_group_id" {
#   type        = string
#   description = "Application security group allowed to access RDS"
# }

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment"
}

variable "storage_type" {
  type        = string
  description = "Storage type"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage size in GB"
}

variable "db_backup_retention_period" {
  type        = number
  description = "Number of days to retain backups"
}

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection for RDS"
}

variable "db_backup_window" {
  type        = string
  description = "Preferred backup window (UTC)"
}

variable "tags_versus_app" {
  type        = map(string)
  description = "Tags applied to all resources"
}

###########################################
# AWS RDS MySQL CloudWatch Alarm Variables
###########################################
variable "alarm_name" {
  type        = string
  description = "Name of the CloudWatch alarm"

}

variable "cpu_threshold" {
  type    = number
  default = 80
}

variable "rds_cpu_alerts" {
  type        = string
  description = "Name of the SNS topic for RDS CPU alerts"
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

# DocumentDB Module Variables
variable "name_prefix" {
  type = string
}
variable "mongo_db_instance_class" {
  type = string
}
variable "tags_proshop" {
  type = map(string)
}
variable "master_username" {
  type = string
}
variable "enable_addons" {
  type    = bool
  default = false
}

variable "instance_count" {
  type = number
}