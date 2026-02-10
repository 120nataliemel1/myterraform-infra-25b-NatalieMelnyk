############################################
# EKS Add-ons (managed by EKS, declared in Terraform)
# Purpose: install and manage core Kubernetes components like CNI, CoreDNS, kube-proxy, and EBS CSI driver using EKS Add-ons.
############################################

# VPC CNI: short for "Virtual Private Cloud Container Network Interface". This is the default CNI plugin for EKS that provides pod networking by creating ENIs (Elastic Network Interfaces) on worker nodes. It allows pods to have IP addresses from the VPC and enables features like security groups for pods and VPC-native networking.
# VPC CNI: pod networking (aws-node daemonset)
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.projectx_cluster.name # target cluster
  addon_name   = "vpc-cni"                             # official addon name

  # Best practice: avoid hardcoding unless you must pin versions.
  addon_version = data.aws_eks_addon_version.vpc_cni.version

  resolve_conflicts_on_create = "OVERWRITE" # replace if something already exists
  resolve_conflicts_on_update = "OVERWRITE" # keep Terraform as source of truth
}

# CoreDNS: Kubernetes cluster DNS (coredns deployment in kube-system namespace). CoreDNS provides DNS-based service discovery for pods and services within the cluster. It allows pods to resolve the names of other services and pods, enabling communication between them using DNS names instead of IP addresses.
# CoreDNS: cluster DNS (coredns deployment in kube-system)
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.projectx_cluster.name
  addon_name   = "coredns"

  addon_version = data.aws_eks_addon_version.coredns.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

# kube-proxy: Kubernetes network proxy (kube-proxy daemonset in kube-system namespace). kube-proxy is responsible for maintaining network rules on each worker node to allow communication between pods and services. It manages the routing of traffic to the appropriate pods based on service definitions and ensures that network policies are enforced.
# kube-proxy: node networking rules (iptables/ipvs rules on nodes)
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.projectx_cluster.name
  addon_name   = "kube-proxy"

  addon_version = data.aws_eks_addon_version.kube_proxy.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

############################################
# EBS CSI Driver (requires IRSA via OIDC)
# Purpose: allow Kubernetes to dynamically provision EBS volumes (PVCs)
############################################

# Fetch cluster OIDC issuer so IAM can trust Kubernetes service accounts
data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.projectx_cluster.name
}

# Trust anchor for IRSA (OIDC provider derived from the cluster issuer URL)
data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  #   client_id_list = ["sts.amazonaws.com"] # standard IRSA audience
}

# IRSA trust policy: allow ONLY the EBS CSI service account to assume this role
data "aws_iam_policy_document" "ebs_csi_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"] # required for IRSA

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.this.arn]
    }

    # Lock it to ONLY the EBS CSI controller service account
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    # Lock it to the standard IRSA audience (prevents misuse)
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# IAM role that EBS CSI controller uses (via IRSA) to call EC2/EBS APIs
resource "aws_iam_role" "ebs_csi_irsa_role" {
  name               = "${var.cluster_name}-ebs-csi-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role.json
}
# look into ebs csi add on check access-entries.terraform #############################


# Attach AWS-managed policy that grants required EBS permissions
resource "aws_iam_role_policy_attachment" "ebs_csi_policy_attach" {
  role       = aws_iam_role.ebs_csi_irsa_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# resource "aws_iam_role" "ebs_csi_irsa_role" {
#   name = "${var.cluster_name}-ebs-csi-irsa-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Principal = {
#         Federated = aws_iam_openid_connect_provider.eks_oidc_provider.arn
#       },
#       Action = "sts:AssumeRoleWithWebIdentity",
#       Condition = {
#         StringEquals = {
#           "${replace(aws_iam_openid_connect_provider.eks_oidc_provider.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
#         }
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ebs_csi_irsa_policy" {
#   role       = aws_iam_role.ebs_csi_irsa_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
# }

# Note: the EBS CSI addon must be created after the IRSA role and policy are in place, otherwise it will fail to create. This is because the addon needs to link to the IRSA role at creation time. The "depends_on" in the addon resource ensures this order.
# EBS CSI Driver: allows Kubernetes to dynamically provision EBS volumes (PVCs) using the AWS EBS CSI driver. This addon enables Kubernetes to manage EBS volumes as persistent storage for applications running in the cluster. With this addon, you can create PersistentVolumeClaims (PVCs) that automatically provision EBS volumes and attach them to your pods as needed.
# EBS CSI add-on itself (wired to the IRSA role above)

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.projectx_cluster.name
  addon_name   = "aws-ebs-csi-driver"

  addon_version = data.aws_eks_addon_version.ebs_csi.version

  service_account_role_arn    = aws_iam_role.ebs_csi_irsa_role.arn # key IRSA link
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_iam_role_policy_attachment.ebs_csi_policy_attach] # ensure policy is attached first
}

############################################
# Optional: automatically pick latest compatible addon versions
# (recommended if you want "pinning" without guessing strings)
############################################

data "aws_eks_addon_version" "vpc_cni" {
  addon_name         = "vpc-cni"
  kubernetes_version = aws_eks_cluster.projectx_cluster.version
  most_recent        = true
}

data "aws_eks_addon_version" "coredns" {
  addon_name         = "coredns"
  kubernetes_version = aws_eks_cluster.projectx_cluster.version
  most_recent        = true
}

data "aws_eks_addon_version" "kube_proxy" {
  addon_name         = "kube-proxy"
  kubernetes_version = aws_eks_cluster.projectx_cluster.version
  most_recent        = true
}

data "aws_eks_addon_version" "ebs_csi" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = aws_eks_cluster.projectx_cluster.version
  most_recent        = true
}
