output "controller_role_arn" {
  description = "IAM role ARN assumed by the Karpenter controller service account (IRSA)"
  value       = aws_iam_role.karpenter_controller_role.arn
}

output "node_role_arn" {
  description = "IAM role ARN used by Karpenter-provisioned EC2 nodes"
  value       = aws_iam_role.karpenter_node_role.arn
}

output "node_instance_profile_name" {
  description = "Instance profile name used by Karpenter nodes"
  value       = aws_iam_instance_profile.karpenter_node_instance_profile.name
}
