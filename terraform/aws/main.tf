terraform {
  backend "s3" {
    bucket = "uncertainty-tfstate"
    key    = "ratingcurve-demo.tfstate"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.8"
    }
  }
}


provider "aws" {
  region = var.region
  default_tags { tags = var.aws_tags }
}
