terraform {

  ### Example of how to configure S3 Backage for state storage with locking
  #   backend "s3" {
  #     bucket         = "tfstate"
  #     key            = "m3-demo.tfstate"
  #     region         = "us-east-1"
  #     dynamodb_table = "tfstate-locking"
  #   }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.59.0"
    }
  }
}

### This assumes you have the AWS Cli configured and working.
provider "aws" {
  region = "us-east-1"
}
