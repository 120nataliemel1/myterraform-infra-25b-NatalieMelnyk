# Security Group for EKS Nodes to communicate with the EKS Cluster
# Ingress to Nodes from Control Plane: Allow communication from the EKS control plane to the nodes.
resource "aws_security_group" "eks_node_sg" {
  name        = "${var.cluster_name}-node-sg"
  description = "Security group for EKS self-managed nodes"
  vpc_id      = module.vpc-module.vpc_id

  tags = {
    Name = "${var.cluster_name}-node-sg"
    # Tagging is important for Kubernetes discovery
    "kubernetes.io/cluster/${var.cluster_name}" = "owned" 
  }
}

# Example rule: Egress to the EKS control plane API server (port 443)
# Egress from Nodes to Control Plane: Allow the worker nodes to reach the EKS control plane API server endpoint (port 443).
resource "aws_security_group_rule" "egress_to_cluster_api" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_node_sg.id # Security group of the EKS nodes
  # Destination should be the EKS cluster security group or API endpoint
  destination_security_group_id = aws_security_group.eks_node_sg.id 
}

# Example rule: Ingress from the control plane
# This rule allows the EKS control plane to communicate with the worker nodes on port 10250 (Kubelet port).
resource "aws_security_group_rule" "ingress_from_cluster_api" {
  type              = "ingress"
  from_port         = 10250 # Kubelet port
  to_port           = 10250
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_node_sg.id
  source_security_group_id = module.eks-module.cluster_security_group_id
}

# Security Group for EKS Cluster Control Plane. This SG allows communication from the EKS nodes to the control plane.
resource "aws_security_group" "cluster_sg" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = module.vpc-module.vpc_id

  tags = {
    Name = "${var.cluster_name}-cluster-sg"
    # Tagging is important for Kubernetes discovery
    "kubernetes.io/cluster/${var.cluster_name}" = "owned" 
  }
}


# integrate later sg rules in sg
#Add sg in outputs! for mangoDB
# change resource names + variable with 25b-ubuntu suffix

