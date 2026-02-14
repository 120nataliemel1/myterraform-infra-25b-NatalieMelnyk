# EKS optimized AL2023 worker AMI (K8s 1.34)
data "aws_ssm_parameter" "eks_worker_ami" {
  name = "/aws/service/eks/optimized-ami/1.34/amazon-linux-2023/x86_64/standard/recommended/image_id"
}

resource "aws_launch_template" "workers_lt" {
  name_prefix   = "${var.cluster_name}-workers-lt-"
  ebs_optimized = true

  iam_instance_profile {
    name = aws_iam_instance_profile.workers_instance_profile.name
  }

  image_id                             = data.aws_ssm_parameter.eks_worker_ami.value
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t3.medium"

  #   key_name = <<< YOUR_KEY_PAIR_NAME >>>

  lifecycle {
    create_before_destroy = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.eks_node_sg.id, aws_eks_cluster.projectx_cluster.vpc_config[0].cluster_security_group_id
  ]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name                                        = "${var.cluster_name}-instance"
      project_name                                = var.project_name
      environment                                 = var.environment
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"


    }
  }

  tag_specifications {
    resource_type = "network-interface"
    tags = {
      project_name                                = var.project_name
      environment                                 = var.environment
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  }

  # nodeadm config (templatefile output must be valid NodeConfig YAML for AL2023)
  user_data = base64encode(templatefile("${path.module}/userdata-workers.sh.tpl", {
    cluster_name     = var.cluster_name
    cluster_endpoint = aws_eks_cluster.projectx_cluster.endpoint
    cluster_ca_b64   = aws_eks_cluster.projectx_cluster.certificate_authority[0].data
    service_cidr     = aws_eks_cluster.projectx_cluster.kubernetes_network_config[0].service_ipv4_cidr # try to remove this and see if it works without it. 
  }))
}


