terraform {

  backend "s3" {
    bucket         = "terraformstate"
    key            = "IaaC/s3/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "365-eft-terraform-state-locks"
    encrypt        = true
  }

  required_version = "~> 1.3.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "${var.aws_region}"

  default_tags {
    tags = {
      Environment = "${var.environment}"
      DeployedBy  = "Terraform"
    }
  }
}


