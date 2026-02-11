# EKS Worker AMI (recommended) (worker node OS image)
# This pulls the OFFICIAL EKS-optimized Amazon Linux 2023 AMI for Kubernetes v1.34 (x86_64, standard).
# "Recommended" means AWS keeps this updated with the right patches + EKS components.
# This matches our worker instance types like t3.medium (x86_64) and aligns with the task requirement
# to run Kubernetes 1.34 and use self-managed ASG worker nodes without hardcoding AMI IDs.
data "aws_ssm_parameter" "eks_worker_ami" {
  name = "/aws/service/eks/optimized-ami/1.34/amazon-linux-2023/x86_64/standard/recommended/image_id"

}

resource "aws_launch_template" "workers_lt" {
  name_prefix = "${var.cluster_name}-workers-lt-"



  # Root disk mapping:
  # We are NOT hardcoding a root device name (like /dev/xvda or /dev/sda1) because the EKS-optimized AMI
  # already defines the correct root device mapping for modern EC2 instances.
  # Leaving it to the AMI avoids mismatches and keeps the launch template simpler and more reliable.
  # Since the task doesn’t ask for custom disk sizing/encryption, we keep it default.
  # If you wanted to customize the root volume (e.g., larger size, different type), you could add a block_device_mappings section here.
  # Device Mapping is used for defining the root volume and any additional EBS volumes for the EC2 instances launched with this template.

  #   block_device_mappings {
  #     device_name = "/dev/xvda" 
  #     ebs {
  #       volume_size = <<< ROOT_VOLUME_SIZE_GB >>>
  #       volume_type = "<<< ROOT_VOLUME_TYPE >>>" 
  #       delete_on_termination = true
  #     }
  #   }

  # disable_api_stop = true
  ebs_optimized = true

  # This allows EC2 instances launched with this template to assume the IAM role defined in the instance profile, granting them the necessary permissions to function as EKS worker nodes.
  iam_instance_profile {
    name = aws_iam_instance_profile.workers_instance_profile.name
  }
  # AMI ID from SSM Parameter Store for EKS-optimized worker nodes
  image_id = data.aws_ssm_parameter.eks_worker_ami.value

  instance_initiated_shutdown_behavior = "terminate"

  # pick a sane default instance type (ASG will override with mixed policy if you set it there)
  instance_type = "t3.medium"

  #   key_name = <<< YOUR_KEY_PAIR_NAME >>>

  lifecycle {
    create_before_destroy = true
  }

  # Metadata security:
  # This locks down the EC2 metadata service (IMDSv2 required) to help protect AWS creds.
  # Hop limit 1 keeps metadata local to the instance. Tags are enabled for easier debugging/ops.
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  # Value: attach your node security group(s)
  vpc_security_group_ids = [aws_security_group.eks_node_sg.id]
  # This ensures that the worker nodes launched with this template are associated with the correct security group, allowing them to communicate with the EKS control plane and other necessary resources while adhering to the defined security rules.
  # Cluster SG do not need to be attached to worker nodes, as it's only used by control plane ENIs.

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name         = "${var.cluster_name}-instance"
      project_name = var.project_name
      environment  = var.environment
      # "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  }

  tag_specifications {
    resource_type = "network-interface"
    tags = {
      project_name = var.project_name
      environment  = var.environment
      # "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  }


  # User data:
  # Startup script that bootstraps each EC2 instance as an EKS worker. 
  # It runs on first boot and tells the node which cluster to join. (“You are an EKS worker — here’s the cluster you belong to. Join it.” Without this, the EC2 instances would start… but never join the EKS cluster.)
  # Required because we are using self-managed ASG workers (not managed node groups). (AWS will NOT auto-join nodes for you)
  user_data = base64encode(templatefile("${path.module}/userdata-workers.sh.tpl", {
    cluster_name     = var.cluster_name
    cluster_endpoint = aws_eks_cluster.projectx_cluster.endpoint
    cluster_ca_b64   = aws_eks_cluster.projectx_cluster.certificate_authority[0].data
    service_cidr     = data.aws_eks_cluster.projectx.kubernetes_network_config[0].service_ipv4_cidr
  }))
}
