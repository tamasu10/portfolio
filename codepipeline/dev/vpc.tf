######################################################################################
# VPC
# name rule : vpc-[system]-[account]-[env]-[component]-[region]
######################################################################################
locals {
  subnets = {
    for k, v in var.subnets :
    k => {
      availability_zone = v["availability_zone"]
      cidr              = v["cidr"]
      isPublic          = v["isPublic"]
      name              = format(v["name"], var.system, var.account, var.env)
    }
  }
}

module "vpc" {
  source = "../modules/vpc"

  vpc_name             = format("vpc-%s-%s-%s-test-apn1", var.system, var.account, var.env)
  vpc_cidr             = "10.100.0.0/16"
  tenancy              = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  subnets              = local.subnets
}

######################################################################################
# VPC Flowlog
# name rule :flowlogs-[system]-[account]-[env]-[componet]-[region]
######################################################################################
module "vpc_flow_log" {
  source = "../modules/vpc_flow_log"

  vpc_id              = module.vpc.vpc_id
  flow_log_name       = format("flowlogs-%s-%s-%s-test-apn1", var.system, var.account, var.env)
  iam_role_arn        = module.iam_assumable_role_flowlogs.iam_role_arn
  traffic_type        = "ALL"
  cloudwatch_log_name = format("/aap/%s/%s/%s/flowlogs", var.system, var.account, var.env)
  # iam.tfにて実装のため不要
  # iam_role_name        = format(var.iam["flowlogs"].role_name, var.project, var.env)
  # assume_role_policy   = var.vpc_flow_log.assume_role_policy
  # iam_role_policy_name = format(var.iam["flowlogs"].role_policy_name, var.project, var.env) 
  # policy               = var.iam["flowlogs"].role_policy
}

######################################################################################
# Subnet
# name rule :subnet-[system]-[account]-[env]-[pub|pri]-[component][no2]-[region][az]
######################################################################################
variable "subnets" {
  default = {
    "public-subnet01-d" = {
      availability_zone = "ap-northeast-1d"
      cidr              = "10.100.1.0/24"
      isPublic          = true
      name              = "subnet-%s-%s-%s-nat01-pub-apn1d"
    }

    "private-subnet02-a" = {
      availability_zone = "ap-northeast-1a"
      cidr              = "10.100.2.0/24"
      isPublic          = false
      name              = "subnet-%s-%s-%s-ec2-test01-pri-apn1a"
    }

    "private-subnet03-a" = {
      availability_zone = "ap-northeast-1a"
      cidr              = "10.100.3.0/24"
      isPublic          = false
      name              = "subnet-%s-%s-%s-aurora-test01-pri-apn1a"
    }

    "private-subnet04-c" = {
      availability_zone = "ap-northeast-1c"
      cidr              = "10.100.4.0/24"
      isPublic          = false
      name              = "subnet-%s-%s-%s-aurora-test01-pri-apn1c"
    }

    "private-subnet05-a" = {
      availability_zone = "ap-northeast-1a"
      cidr              = "10.100.5.0/24"
      isPublic          = false
      name              = "subnet-%s-%s-%s-rds-test01-pri-apn1a"
    }

    "private-subnet06-c" = {
      availability_zone = "ap-northeast-1c"
      cidr              = "10.100.6.0/24"
      isPublic          = false
      name              = "subnet-%s-%s-%s-rds-test01-pri-apn1c"
    }
  }
}

