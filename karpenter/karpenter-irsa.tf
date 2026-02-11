# creates the IAM role assumed by the Kubernetes ServiceAccount with trust policy (IRSA role)
resource "aws_iam_role" "karpenter_controller_role" {
  name               = "${var.environment}-karpenter-irsa"
  assume_role_policy = data.aws_iam_policy_document.karpenter_controller_trust.json
}

locals {
  oidc_hostpath = replace(var.oidc_url, "https://", "")
}

# Builds trust policy JSON allowing the EKS ServiceAccount to assume the role
data "aws_iam_policy_document" "karpenter_controller_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_hostpath}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_hostpath}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "karpenter_controller_policy" {
  name   = "KarpenterControllerPolicy"
  policy = data.aws_iam_policy_document.karpenter_controller_permissions.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "karpenter_controller_permissions" {
  statement {
    sid    = "Karpenter"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ec2:DescribeImages",
      "ec2:RunInstances",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DeleteLaunchTemplate",
      "ec2:CreateTags",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateFleet",
      "ec2:DescribeSpotPriceHistory",
      "pricing:GetProducts",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ConditionalEC2Termination"
    effect = "Allow"

    actions   = ["ec2:TerminateInstances"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/karpenter.sh/nodepool"
      values   = ["*"]
    }
  }

  statement {
    sid    = "PassNodeIAMRole"
    effect = "Allow"

    actions = ["iam:PassRole"]
    resources = [
      aws_iam_role.karpenter_node_role.arn
    ]
  }

  statement {
    sid    = "EKSClusterEndpointLookup"
    effect = "Allow"

    actions = ["eks:DescribeCluster"]
    resources = [
      aws
    ]
  }

  statement {
    sid    = "AllowScopedInstanceProfileCreationActions"
    effect = "Allow"

    actions   = ["iam:CreateInstanceProfile"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${var.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = [var.region]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"
      values   = ["*"]
    }
  }

  statement {
    sid    = "AllowScopedInstanceProfileTagActions"
    effect = "Allow"

    actions   = ["iam:TagInstanceProfile"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/topology.kubernetes.io/region"
      values   = [var.region]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${var.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = [var.region]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass"
      values   = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"
      values   = ["*"]
    }
  }

  statement {
    sid    = "AllowScopedInstanceProfileActions"
    effect = "Allow"

    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:DeleteInstanceProfile",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${var.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/topology.kubernetes.io/region"
      values   = [var.region]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass"
      values   = ["*"]
    }
  }

  statement {
    sid    = "AllowInstanceProfileReadActions"
    effect = "Allow"

    actions   = ["iam:GetInstanceProfile"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowUnscopedInstanceProfileListAction"
    effect = "Allow"

    actions   = ["iam:ListInstanceProfiles"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "karpenter_controller" {
  role       = aws_iam_role.karpenter_controller_role.name
  policy_arn = aws_iam_policy.karpenter_controller_policy.arn
}