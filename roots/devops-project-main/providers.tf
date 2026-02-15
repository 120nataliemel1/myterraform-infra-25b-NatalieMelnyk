provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
   #bucket         = "versus-rds-mysql-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraformlock"
  }
}