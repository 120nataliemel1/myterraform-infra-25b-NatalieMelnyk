resource "aws_iam_role" "iam_role" {
  name = var.role_name


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
    Name        = var.role_name
    environment = var.environment
  }
}


resource "aws_iam_policy" "iam_policy" {
  name   = "${var.role_name}-policy"
  policy = file("${path.module}/policies/${var.policy_json}")

  tags = {
    Name        = "iam_policy_${var.role_name}"
    environment = var.environment
  }
}


resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}