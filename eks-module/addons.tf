############################################
# EKS Add-ons (Terraform)
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

############################################
# Core EKS add-ons
############################################

resource "aws_eks_addon" "vpc_cni" {
  count         = var.enable_addons ? 1 : 0
  cluster_name  = aws_eks_cluster.projectx_cluster.name
  addon_name    = "vpc-cni"
  addon_version = data.aws_eks_addon_version.vpc_cni.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "coredns" {
  count         = var.enable_addons ? 1 : 0
  cluster_name  = aws_eks_cluster.projectx_cluster.name
  addon_name    = "coredns"
  addon_version = data.aws_eks_addon_version.coredns.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "kube_proxy" {
  count         = var.enable_addons ? 1 : 0
  cluster_name  = aws_eks_cluster.projectx_cluster.name
  addon_name    = "kube-proxy"
  addon_version = data.aws_eks_addon_version.kube_proxy.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

############################################
# EBS CSI (IRSA)
############################################

# Read cluster identity (OIDC issuer)
data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.projectx_cluster.name
}

# OIDC provider for IRSA
data "tls_certificate" "oidc" {
  url = aws_eks_cluster.projectx_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  url             = aws_eks_cluster.projectx_cluster.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
}

# IRSA role for EBS CSI controller service account
resource "aws_iam_role" "ebs_csi_irsa_role" {
  name = "${var.cluster_name}-ebs-csi-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.this.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa",
          "${replace(aws_iam_openid_connect_provider.this.url, "https://", "")}:aud" = "sts.amazonaws.com"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_irsa_policy" {
  role       = aws_iam_role.ebs_csi_irsa_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# EBS CSI managed add-on (uses IRSA role)
resource "aws_eks_addon" "ebs_csi" {
  count         = var.enable_addons ? 1 : 0
  cluster_name  = aws_eks_cluster.projectx_cluster.name
  addon_name    = "aws-ebs-csi-driver"
  addon_version = data.aws_eks_addon_version.ebs_csi.version

  service_account_role_arn    = aws_iam_role.ebs_csi_irsa_role.arn
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [aws_iam_role_policy_attachment.ebs_csi_irsa_policy]
}
