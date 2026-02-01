greeting = "Hi"

iam_roles = {
  DeveloperDevAccessRole-ubuntu25b = {
    principal_type      = "AWS"
    principal           = "arn:aws:iam::879500880845:root"
    action              = ["s3:*", "ec2:Describe*", "eks:DescribeCluster", "eks:ListClusters", "eks:AccessKubernetesApi"]
    enable_secrets_deny = true
    resource            = ["*"]
  }
  DevopsDevAccessRole-ubuntu25b = {
    principal_type      = "AWS"
    principal           = "arn:aws:iam::879500880845:root"
    enable_secrets_deny = false
    action              = ["*"]
    resource            = ["*"]
  }
}