# Node SG (worker instances)
resource "aws_security_group" "eks_node_sg" {
  name        = "${var.cluster_name}-node-sg"
  description = "Security group for EKS self-managed nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name                                        = "${var.cluster_name}-node-sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    project_name                                = var.project_name
    environment                                 = var.environment
  }
}

# Cluster SG (control plane ENIs)
resource "aws_security_group" "cluster_sg" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  tags = {
    Name                                        = "${var.cluster_name}-cluster-sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    project_name                                = var.project_name
    environment                                 = var.environment
  }
}

# Workers -> API Server (443)
# resource "aws_vpc_security_group_egress_rule" "nodes_to_controlplane_443" {
#   security_group_id            = aws_security_group.eks_node_sg.id
#   ip_protocol                  = "tcp"
#   from_port                    = 443
#   to_port                      = 443
#   referenced_security_group_id = aws_security_group.cluster_sg.id
#   description                  = "Nodes -> control plane API (443)"
# }

resource "aws_vpc_security_group_egress_rule" "nodes_all_egress" {
  security_group_id = aws_security_group.eks_node_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Nodes egress all (required for bootstrap/pulls/AWS APIs)"

}

# resource "aws_vpc_security_group_ingress_rule" "cluster_api_443_from_nodes" {
#   security_group_id            = aws_security_group.cluster_sg.id
#   ip_protocol                  = "tcp"
#   from_port                    = 443
#   to_port                      = 443
#   referenced_security_group_id = aws_security_group.eks_node_sg.id
#   description                  = "Allow nodes -> control plane API (443)"
# }

resource "aws_vpc_security_group_ingress_rule" "cluster_all_from_nodes" {
  security_group_id            = aws_security_group.cluster_sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.eks_node_sg.id
  description                  = "TESTING: allow all traffic from nodes to control plane SG"
}

# # Control plane -> kubelet (10250)
# resource "aws_vpc_security_group_ingress_rule" "controlplane_to_nodes_10250" {
#   security_group_id            = aws_security_group.eks_node_sg.id
#   ip_protocol                  = "tcp"
#   from_port                    = 10250
#   to_port                      = 10250
#   referenced_security_group_id = aws_security_group.cluster_sg.id
#   description                  = "Control plane -> nodes kubelet (10250)"
# }

resource "aws_vpc_security_group_ingress_rule" "nodes_all_from_cluster" {
  security_group_id            = aws_security_group.eks_node_sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.cluster_sg.id
  description                  = "TESTING: allow all traffic from control plane SG to nodes"
}

# resource "aws_vpc_security_group_egress_rule" "controlplane_to_nodes_10250_egress" {
#   security_group_id            = aws_security_group.cluster_sg.id
#   ip_protocol                  = "tcp"
#   from_port                    = 10250
#   to_port                      = 10250
#   referenced_security_group_id = aws_security_group.eks_node_sg.id
#   description                  = "Control plane -> nodes kubelet (10250)"
# }

resource "aws_vpc_security_group_egress_rule" "cluster_all_to_nodes" {
  security_group_id            = aws_security_group.cluster_sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.eks_node_sg.id
  description                  = "TESTING: allow control plane SG to talk to nodes on any port"
}

# Node-to-node communication (inside the node group)
resource "aws_vpc_security_group_ingress_rule" "node_to_node_all" {
  security_group_id            = aws_security_group.eks_node_sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.eks_node_sg.id
  description                  = "Node-to-node all traffic"
}



