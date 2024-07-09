terraform {

  backend "s3" {
    bucket         = "IaaC-terraformstate"
    key            = "IaaC/vpc/terraform.tfstate"
    region         = "eu-west-2"
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

resource "aws_vpc" "main" {
 cidr_block           = "${var.vpc_cidr}"
 instance_tenancy     = "default"
 enable_dns_support   = true
 enable_dns_hostnames = true
 
 tags = {
    Name        = "${var.environment} vpc"
  }
}

resource "aws_subnet" "public_subnets" {
 depends_on = [
    aws_vpc.main
  ]

 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name        = "${var.environment} Public Subnet ${count.index + 1}"
 }
}
 
resource "aws_subnet" "private_subnets" {
 depends_on = [
    aws_vpc.main
  ]

 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name        = "${var.environment} Private Subnet ${count.index + 1}"
 }
}

resource "aws_internet_gateway" "igw" {
 depends_on = [
    aws_vpc.main,
    aws_subnet.public_subnets,
    aws_subnet.private_subnets
  ]

 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "${var.environment} VPC IGW"
 }
}

resource "aws_route_table" "public_rt" {
 depends_on = [
    aws_vpc.main,
    aws_internet_gateway.igw
  ]

 vpc_id = aws_vpc.main.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
 }
 
 tags = {
   Name = "${var.environment} Public Route Table"
 }
}

resource "aws_route_table_association" "public_subnet_association" {
 depends_on = [
    aws_vpc.main,
    aws_subnet.public_subnets,
    aws_subnet.private_subnets,
    aws_route_table.public_rt
  ]

 count          = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
   depends_on = [
    aws_route_table_association.public_subnet_association
  ]

   vpc   = true

   tags = {
        Name        = "${var.environment} Elastic IP"
    }
 }

resource "aws_nat_gateway" "nat_gw" {
   depends_on = [
    aws_eip.nat_eip
  ]

   allocation_id = aws_eip.nat_eip.id
   subnet_id = aws_subnet.public_subnets[0].id

   tags = {
        Name        = "${var.environment} NAT Gateway"
    }
 }

resource "aws_route_table" "private_rt" {
 depends_on = [
    aws_vpc.main,
    aws_nat_gateway.nat_gw
  ]

 vpc_id = aws_vpc.main.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_nat_gateway.nat_gw.id
 }
 
 tags = {
   Name = "${var.environment} Private Route Table"
 }
}

resource "aws_route_table_association" "private_subnet_association" {
 depends_on = [
    aws_vpc.main,
    aws_subnet.public_subnets,
    aws_subnet.private_subnets,
    aws_route_table.private_rt
  ]

 count          = length(var.private_subnet_cidrs)
 subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
 route_table_id = aws_route_table.private_rt.id
}
