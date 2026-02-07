# Fetches the official EKS-optimized AMI ID from AWS SSM Parameter Store.
# AWS publishes and updates EKS AMIs here. This avoids hard-coding AMI IDs.
# This example fetches the AMI for EKS version 1.34 on Amazon Linux 2.
data "aws_ssm_parameter" "eks_worker_ami" {
  name = "/aws/service/eks/optimized-ami/1.34/amazon-linux-2023/arm64/nvidia/recommended/image_id"

} 
# This AMI will be used for the EKS worker nodes, ensuring they are optimized for EKS and compatible with the specified Kubernetes version.

