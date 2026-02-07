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

