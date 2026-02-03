provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket       = "383585068161-state-bucket-dev"
    key          = "feature/MRP25BUBUN-14-mongodb.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

