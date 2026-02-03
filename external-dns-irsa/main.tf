# Creates a managed IAM policy in AWS using the JSON built below
resource "aws_iam_policy" "external_dns" {
  name        = "${var.env}-external-dns-route53"
  description = "Allow external-dns to manage Route53 records in approved hosted zones"
  policy      = data.aws_iam_policy_document.external_dns_permissions.json
}

# Builds JSON defining Route53 permissions, used in the IAM policy above
# permission edit records in specific zones + list zones 
data "aws_iam_policy_document" "external_dns_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResources",
      "route53:GetHostedZone",
    ]
    resources = [
      for id in var.hosted_zone_ids :
      "arn:aws:route53:::hostedzone/${id}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
    ]
    resources = ["*"]
  }
}

# creates the IAM role assumed by the Kubernetes ServiceAccount with trust policy (IRSA role)
resource "aws_iam_role" "external_dns" {
  name               = "${var.env}-external-dns-irsa"
  assume_role_policy = data.aws_iam_policy_document.external_dns_trust.json
}

# Builds trust policy JSON allowing the EKS ServiceAccount to assume the role
data "aws_iam_policy_document" "external_dns_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }
  }
}

# Attaches the Route53 permissions policy to the external-dns IAM role
resource "aws_iam_role_policy_attachment" "external_dns_attach" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.external_dns.arn
}