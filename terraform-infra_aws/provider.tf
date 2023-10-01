terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

provider "aws" {
  shared_config_files      = ["/home/claudio/.aws/config"]
  shared_credentials_files = ["/home/claudio/.aws/credentials"]
  profile                  = "default"
  region                   = "us-east-1"
}