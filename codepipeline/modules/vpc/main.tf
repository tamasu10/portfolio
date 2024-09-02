######################################################################################
# VPC
######################################################################################

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = var.vpc_name
  }
}

######################################################################################
# Subnet
######################################################################################

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id

  for_each                = var.subnets
  cidr_block              = var.subnets[each.key].cidr
  availability_zone       = var.subnets[each.key].availability_zone
  map_public_ip_on_launch = var.subnets[each.key].isPublic
  tags = {
    Name = var.subnets[each.key].name
  }
}