greeting = "Hi"

iam_roles = {
  DeveloperProdAccessRole-ubuntu25b = {
    principal_type = "AWS"
    principal      = "arn:aws:iam::879500880845:root"
    action         = ["s3:GetObject", "s3:ListBucket", "ec2:Describe*", "eks:DescribeCluster"]
    resource       = ["*"]
  }

  DevopsProdAccessRole-ubuntu25b = {
    principal_type = "AWS"
    principal      = "arn:aws:iam::879500880845:root"
    action         = ["ec2:*", "*:Describe*", "*:List*", "*:Get*"]
    resource       = ["*"]
  }
}

