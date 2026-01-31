greeting = "Hi"

iam_roles = {
  DeveloperProdAccessRole = {
    principal_type = "AWS"
    principal      = "arn:aws:iam::879500880845:root"
    action         = ["s3:GetObject", "s3:ListBucket", "ec2:Describe*", "eks:DescribeCluster"]
    resource       = ["*"]
  }

  DevopsProdAccessRole = {
    principal_type = "AWS"
    principal      = "arn:aws:iam::879500880845:root"
    action         = ["ec2:*", "*:Describe*", "*:List*", "*:Get*"]
    resource       = ["*"]
  }
}

