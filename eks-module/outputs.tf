# Output the security group ID for the EKS cluster for use in other modules
output "cluster_security_group_id" {
  description = "The security group ID for the EKS cluster control plane"
  value       = aws_eks_cluster.projectx_cluster.vpc_config[0].cluster_security_group_id
}

# Output the security group ID for the EKS worker nodes for use in other modules
output "node_security_group_id" {
  description = "The security group ID for the EKS worker nodes"
  value       = aws_security_group.eks_node_sg.id
}



