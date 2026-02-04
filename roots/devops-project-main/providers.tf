provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    # bucket         = "project-x-state-bucket-staging"
    bucket       = "terraform-remote-state-altynai"
    key          = "dev/versus/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

