resource "aws_iam_role" "iam_role" {
  name = var.name


  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "${var.principal_type}" = var.principal
        }
      },
    ]
  })

  tags = {
    tag-key = var.name
  }
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    effect    = "Allow"
    actions   = var.action
    resources = var.resource
  }

  dynamic "statement" {
    for_each = var.enable_secrets_deny ? [1] : []
    content {
      effect    = "Deny"
      actions   = ["secretsmanager:*", "ssm:GetParameter*", "ssm:Describe*"]
      resources = ["*"]
    }
  }
}

resource "aws_iam_policy" "iam_policy" {
  name   = "${var.name}-policy"
  policy = data.aws_iam_policy_document.role_policy.json
}


resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}