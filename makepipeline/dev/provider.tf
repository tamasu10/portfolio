terraform {
  required_version = "1.1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {
  profile = "arise-pod-dev"
  region  = "ap-northeast-1"

  default_tags {
    tags = {
      System      = var.system
      Environment = var.env
      Owner       = var.owner
      Terraform   = "TRUE"
    }
  }
}