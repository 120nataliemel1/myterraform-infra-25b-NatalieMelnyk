#############################################
# EKS Security Groups (cluster + nodes)
# Goal: let nodes talk to the control plane (API),
# and let the control plane talk back to nodes (kubelet).
#############################################

############################
# 1) Node Security Group
############################
# What: SG attached to worker nodes (EC2).
# Why: Controls what the nodes can reach and who can reach the nodes.

resource "aws_security_group" "eks_node_sg" {
  name        = "${var.cluster_name}-node-sg" # Human-friendly name
  description = "Security group for EKS self-managed nodes"
  vpc_id      = var.vpc_id # VPC where the SG lives (passed into module)

  tags = {
    Name = "${var.cluster_name}-node-sg"
    # Why: helps AWS/K8s tooling discover resources tied to this cluster.
    # Value "owned" means: created specifically for this cluster (not shared across clusters).
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

########################################
# 2) Cluster (Control Plane) Security Group
########################################
# What: SG used by the EKS control plane ENIs inside your VPC.
# Why: Lets you control traffic between control plane and nodes (least-permissive).
resource "aws_security_group" "cluster_sg" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  tags = {
    Name                                        = "${var.cluster_name}-cluster-sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

########################################
# 3) Nodes -> Control plane API (443)
########################################
# What: nodes must reach Kubernetes API server over HTTPS (443).
# Why: without this, nodes cannot join / talk to the cluster.
resource "aws_vpc_security_group_egress_rule" "nodes_to_controlplane_443" {
  security_group_id            = aws_security_group.eks_node_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  referenced_security_group_id = aws_security_group.cluster_sg.id
  description                  = "Nodes -> control plane API (443)"
}

########################################
# Cluster SG: allow inbound API traffic (443) from worker nodes
# What: lets nodes reach the Kubernetes API endpoint.
# Why: API server ENIs are protected by the cluster SG, so inbound must be allowed here.
resource "aws_vpc_security_group_ingress_rule" "cluster_api_443_from_nodes" {
  security_group_id            = aws_security_group.cluster_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  referenced_security_group_id = aws_security_group.eks_node_sg.id
  description                  = "Allow nodes -> control plane API (443)"
}

########################################
# 4) Control plane -> Nodes (kubelet 10250)
########################################
# What: control plane needs to reach kubelet on nodes (10250).
# Why: used for node management/health checks and some operations.
resource "aws_vpc_security_group_ingress_rule" "controlplane_to_nodes_10250" {
  security_group_id            = aws_security_group.eks_node_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 10250
  to_port                      = 10250
  referenced_security_group_id = aws_security_group.cluster_sg.id
  description                  = "Control plane -> nodes kubelet (10250)"
}

# What: cluster SG must allow outbound 10250 to nodes.
# Why: this is *not* return traffic — it’s an outbound connection from control plane to nodes.
resource "aws_vpc_security_group_egress_rule" "controlplane_to_nodes_10250_egress" {
  security_group_id            = aws_security_group.cluster_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 10250
  to_port                      = 10250
  referenced_security_group_id = aws_security_group.eks_node_sg.id
  description                  = "Control plane SG -> nodes kubelet (10250)"
}

########################################
# 5) Node-to-node communication (inside the node group)
########################################
# What: nodes must talk to each other for cluster networking.
# Why: without this, pods/services may break.
# Least-permissive note: this is broad, but safe/stable for first bring-up.
resource "aws_vpc_security_group_ingress_rule" "node_to_node_all" {
  security_group_id            = aws_security_group.eks_node_sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.eks_node_sg.id
  description                  = "Node-to-node all traffic"
}


# In this step, we created two security groups to control communication between the EKS control plane and the worker nodes in a least-permissive way. 
# The cluster security group protects the EKS API and control plane network interfaces, while the node security group protects the EC2 instances that run workloads. 
# We explicitly allowed only the required traffic: nodes can reach the Kubernetes API on port 443, the control plane can reach node kubelets on port 10250, and nodes can communicate with each other for cluster networking. 
# These rules are scoped security-group-to-security-group, not open CIDRs, which keeps access tightly controlled. 
# If these security groups or rules were missing or misconfigured, nodes would fail to join the cluster, kubelet health checks would break, and the cluster would appear “up” but be unusable in practice. 
# Together, these security groups form the network trust boundary that allows EKS to function securely.


# change resource names + variable with 25b-ubuntu suffix

