#vpc_id
terraform {

  backend "s3" {
    bucket         = "IaaC-terraformstate"
    key            = "IaaC/sg/terraform.tfstate"
    region         = "eu-east-2"
    dynamodb_table = "IaaC-terraform-state-locks"
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

data "terraform_remote_state" "remote_state_vpc" {
  backend = "s3"
  config = {
    bucket = "IaaC-terraformstate"
    key = "IaaC/vpc/terraform.tfstate"
    region = "eu-east-2"
  }
}

resource "aws_security_group" "alb_sg" {
  vpc_id = data.terraform_remote_state.remote_state_vpc.outputs.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment} alb sg"
  }
}

resource "aws_security_group" "ecs_tasks_sg" {
  vpc_id = data.terraform_remote_state.remote_state_vpc.outputs.vpc_id
 
  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
   protocol         = "tcp"
   from_port        = 8080
   to_port          = 8080
   cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
   protocol         = "tcp"
   from_port        = 8085
   to_port          = 8085
   cidr_blocks      = ["0.0.0.0/0"]
  }
 
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment} ecs tasks sg"
  }
}
