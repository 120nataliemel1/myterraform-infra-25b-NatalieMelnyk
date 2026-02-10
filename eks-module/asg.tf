
# This Terraform configuration defines an Auto Scaling Group (ASG) for worker nodes in an EKS cluster. 
# It uses a mixed instances policy to allow for a combination of On-Demand and Spot instances, optimizing for cost while maintaining availability.
resource "aws_autoscaling_group" "workers_asg" {
  name             = "${var.cluster_name}-workers-asg"
  min_size         = var.min_size # keep at least 1 node so the cluster always has compute
  max_size         = var.max_size # cap to control cost / match requirement
  desired_capacity = var.desired_capacity # target baseline nodes for platform tools and workloads to run on

  # Public Subnet IDs where the ASG will launch instances. Launch workers across multiple public subnets/AZs for high availability.
  vpc_zone_identifier = var.subnets

  # Use EC2 health checks (ASG checks instance health, not Kubernetes readiness)
  health_check_type         = "EC2"
  health_check_grace_period = 300 # Time for instances to initialize before health checks start. Give nodes time to boot + run EKS bootstrap

  # Mix instance types + mix Spot/On-Demand for cost optimization and availability. This allows the ASG to use a variety of instance types and purchase options based on capacity needs and spot market conditions.
  mixed_instances_policy {
    # Tell the ASG which Launch Template to use for AMI, userdata, SG, IAM, etc.
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.workers_lt.id
        version            = "$Latest" # Use the latest version of the launch template
      }

      # Allowed worker instance types (ASG will choose based on availability)   
      override { instance_type = "t3.medium" } 
      override { instance_type = "t4g.medium" }
      override { instance_type = "t3a.medium" }
    }

    # dynamic "override" {
    #     for_each = var.ec2_types
    #     content {                           # 1 try to run instance types dynamically with variables. 
    #       instance_type = override.value
    #     }
    #   }

    # Enforce 20% On-Demand / 80% Spot (Spot portion is implied by the 20% rule)
    instances_distribution {
      on_demand_base_capacity                  = 0                    # no guaranteed On-Demand “base” capacity, so all capacity is flexible for spot optimization
      on_demand_percentage_above_base_capacity = 20                   # 20% of desired capacity is On-Demand, the rest can be Spot
      spot_allocation_strategy                 = "lowest-price" # pick the cheapest available Spot instance types from the overrides list to fill the remaining capacity after the On-Demand portion is allocated
      # spot_allocation_strategy                 = 80% spot happens automatically bcs: base on-demand = 0: 20% on-demand above base remaining capacity becomes spot
      # spot_max_price                           = "0.03" # Optional: set a max spot price
    }
  }

  # This tag is key/value metadata that gets applied to each EC2 instance launched by this ASG. It helps with resource organization, cost tracking, and cluster management. 
  # The "Name" tag provides a human-readable identifier for the instances. 
  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-worker-node"
    propagate_at_launch = true
  }

  # The "kubernetes.io/cluster/${var.cluster_name}" tag 
  # is used by Kubernetes to identify which nodes belong to which cluster, enabling proper node registration and management within the EKS cluster.
  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = var.environment
    propagate_at_launch = true
  }
  
  depends_on = [ aws_launch_template.workers_lt ]
}
