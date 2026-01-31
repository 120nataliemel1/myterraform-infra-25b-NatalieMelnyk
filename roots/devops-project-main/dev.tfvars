greeting = "Hi"

iam_roles = {
  DeveloperDevAccessRole = {
    principal_type = "AWS"
    principal      = "arn:aws:iam::879500880845:root"
    action         = ["s3:*", "ec2:Describe*", "eks:DescribeCluster"]
    resource       = ["*"]
  }
  DevopsDevAccessRole = {
    principal_type      = "AWS"
    principal           = "arn:aws:iam::879500880845:root"
    enable_secrets_deny = false
    action              = ["*"]
    resource            = ["*"]
  }
}