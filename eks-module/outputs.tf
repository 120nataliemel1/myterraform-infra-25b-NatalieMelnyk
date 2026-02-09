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

# Output the auto scaling group name for the EKS worker nodes for use in other modules
output "workers_asg_name" {
  description = "The name of the Auto Scaling Group for EKS worker nodes"
  value       = aws_autoscaling_group.workers_asg.name
}

# Output the launch template ID for the EKS worker nodes for use in other modules
output "workers_launch_template_id" {
  description = "The ID of the launch template used for EKS worker nodes"
  value       = aws_launch_template.workers_lt.id
}

